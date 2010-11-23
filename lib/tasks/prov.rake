task :default => ["web"]

Resources="Resources/"
def resourcepath(code)
  rp=case code
  when /[A-Z][A-Z]-\d*/
    "jira"
  when "everything"
    "everything"
  else
    "textual_accounts"
  end
  result="#{Resources}#{rp}/#{code}/"
  return result
end

Graphers={
  "ST-50"=>"fdp",
  "SC-47"=>"dot",
  "everything"=>"dot"
}

  Scales={
  "ST-50"=>[8,4],
  "SC-47"=>[8,4],
  "everything"=>[32,4]
}

def scales x
  Scales[x]||[8,4]
end

def goptions(file,s)
  file=File.basename(file,".dot")
  "#{Graphers[file]||'dot'} -Epenwidth=4 -Npenwidth=2 -Estyle=solid -Gfontsize=16 -Gsize=#{scales(file)[0]*s},#{scales(file)[1]*s} -Gratio=fill"
end

def definescale(s)
  rule ".#{s}cmap" => ".dot" do |t|
    sh "cat  #{t.source} | #{goptions(t.source,s)} -Tcmap  -o#{t.name}"
  end
  rule ".#{s}jpeg" => ".dot" do |t|
    sh "cat  #{t.source} | #{goptions(t.source,s)} -Tjpeg -Nfontcolor=blue -o#{t.name}"
  end
end

definescale(1)
definescale(2)
definescale(4)
definescale(8)

rule  '.dot' => '.xml' do |t|
  sh "provenance-ruby/bin/provenance --in #{t.source} --report artifact_graph > #{t.name}"
end
rule '.report' => '.xml' do |t|
  sh "provenance-ruby/bin/provenance --in #{t.source} --report textual > #{t.name}"
end

rule '.xml' do |t|
  begin
    target=File.basename(t.name,'.xml')
    sh "mkdir -p #{resourcepath(target)}"
    case target
    when /[A-Z][A-Z]-\d*/
      switch="-i #{target}"
    when "everything"
      switch="--everything"
    else
      switch="--category #{target.gsub(/-/,"/")}"
    end
    sh "provenance-ruby/bin/provenance -o -x #{switch} > #{t.name}"
  rescue => err
    p "Failed with #{err}, removing partial file".
      rm "#{resourcepath(target)}#{t.name}"
  end
end

task 'clean' do
  rm_rf Dir.glob "#{Resources}*"
  sh "provenance-ruby/bin/provenance --clear"
end

task 'dotclean' do
  rm_rf Dir.glob "#{Resources}**/*.jpeg"
  rm_rf Dir.glob "#{Resources}**/*.cmap"
end

def topartial(code)
  "_"+code.downcase.gsub(/-/,'').gsub(/\//,'_')
end

def scalepage(s,code)
  file "#{resourcepath(code)}#{code}.#{s}cmap" => "#{resourcepath(code)}#{code}.dot"
  file "#{resourcepath(code)}#{code}.#{s}jpeg" => "#{resourcepath(code)}#{code}.dot"
  file "app/views/map/#{topartial(code)}#{s}.erb" =>
    ["#{resourcepath(code)}#{code}.#{s}cmap"] do
    sh "cp #{resourcepath(code)}#{code}.#{s}cmap app/views/map/#{topartial(code)}#{s}.erb"
  end
  file "public/images/#{topartial(code)}.#{s}jpeg" => ["#{resourcepath(code)}#{code}.#{s}jpeg"] do
    sh "mkdir -p public/images"
    sh "cp #{resourcepath(code)}#{code}.#{s}jpeg public/images/#{topartial(code)}.#{s}jpeg"
  end
  task :web => ["app/views/map/#{topartial(code)}#{s}.erb","public/images/#{topartial(code)}.#{s}jpeg"]
end

def preparepage(code)
  file "#{resourcepath(code)}#{code}.xml"
  
  file "#{resourcepath(code)}#{code}.dot" => "#{resourcepath(code)}#{code}.xml"
  file "#{resourcepath(code)}#{code}.report" => "#{resourcepath(code)}#{code}.xml"
  scalepage(1,code)
  scalepage(2,code)
  scalepage(4,code)
  scalepage(8,code)

  file "app/views/report/#{topartial(code)}.erb" =>
    ["#{resourcepath(code)}#{code}.report"] do
    sh "cp #{resourcepath(code)}#{code}.report app/views/report/#{topartial(code)}.erb"
  end

 
  task :web => ["app/views/report/#{topartial(code)}.erb"]
end

preparepage "ST-50"
preparepage "SC-47"
preparepage "everything"
preparepage "transport-car-generic-ghgp-us"