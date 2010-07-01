task :default => ["web"]

Resources="resources/"
Graphers={
  "ST-50"=>"fdp",
  "SC-47"=>"dot"
}
Scales={
  "ST-50"=>[8,4],
  "SC-47"=>[8,4]
}

def goptions(file,s)
  file=File.basename(file,".dot")
  "#{Graphers[file]} -Gsize=#{Scales[file][0]*s},#{Scales[file][1]*s} -Gratio=fill"
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
  sh "provenance-java/target/appassembler/bin/ameeopm #{t.source}"
end
rule '.report' => '.xml' do |t|
  sh "provenance-ruby/bin/provenance --in #{t.source} -q provenance-ruby/config/textual_report.erb > #{t.name}"
end

rule '.xml' do |t|
  begin
    sh "provenance-ruby/bin/provenance -o -x #{File.basename(t.name,'.xml')} > #{t.name}"
  rescue => err
    p "Failed with #{err}, removing partial file".
      rm "#{Resources}#{t.name}"
  end
end

task 'clean' do
  rm Dir.glob "#{Resources}*"
  sh "provenance-ruby/bin/provenance --clear"
end

task 'dotclean' do
  rm Dir.glob "#{Resources}*.jpeg"
  rm Dir.glob "#{Resources}*.cmap"
end

def topartial(code)
  "_"+code.downcase.gsub(/-/,'')
end

def scaleticket(s,code)
  file "#{Resources}#{code}.#{s}cmap" => "#{Resources}#{code}.dot"
  file "#{Resources}#{code}.#{s}jpeg" => "#{Resources}#{code}.dot"
  file "app/views/map/#{topartial(code)}#{s}.erb" =>
    ["#{Resources}#{code}.#{s}cmap"] do
    sh "cp #{Resources}#{code}.#{s}cmap app/views/map/#{topartial(code)}#{s}.erb"
  end
  file "public/images/#{code}.#{s}jpeg" => ["#{Resources}#{code}.#{s}jpeg"] do
    sh "cp #{Resources}#{code}.#{s}jpeg public/images/#{code}.#{s}jpeg"
  end
  task :web => ["app/views/map/#{topartial(code)}#{s}.erb","public/images/#{code}.#{s}jpeg"]
end

def prepareticket(code)
  file "#{Resources}#{code}.xml"
  
  file "#{Resources}#{code}.dot" => "#{Resources}#{code}.xml"
  file "#{Resources}#{code}.report" => "#{Resources}#{code}.xml"
  scaleticket(1,code)
  scaleticket(2,code)
  scaleticket(4,code)
  scaleticket(8,code)

  file "app/views/report/#{topartial(code)}.erb" =>
    ["#{Resources}#{code}.report"] do
    sh "cp #{Resources}#{code}.report app/views/report/#{topartial(code)}.erb"
  end

 
  task :web => ["app/views/report/#{topartial(code)}.erb"]
end

prepareticket "ST-50"
prepareticket "SC-47"