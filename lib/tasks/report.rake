Graphers={
  "ST-50"=>"fdp",
  "SC-47"=>"dot",
  "everything"=>"dot"
}

PageSizes={
  "ST-50"=>[8,4],
  "SC-47"=>[8,4],
  "everything"=>[32,4]
}

def page_size file
 PageSizes[file]||[8,4]
end

def goptions(file,s)
  s||=1
  file=File.basename(file,".dot")
  "#{Graphers[file]||'dot'} -Epenwidth=4 -Npenwidth=2 -Estyle=solid -Gfontsize=16 -Gsize=#{page_size(file)[0]*s},#{page_size(file)[1]*s} -Gratio=fill"
end

Scales.each do |s|
  rule ".#{s}cmap" => ".dot" do |t|
    sh "cat  #{t.source} | #{goptions(t.source,s)} -Tcmap  -o#{t.name}"
  end
  rule ".#{s}jpeg" => ".dot" do |t|
    sh "cat  #{t.source} | #{goptions(t.source,s)} -Tjpeg -Nfontcolor=blue -o#{t.name}"
  end
end

rule  '.dot' => '.xml' do |t|
  sh "provenance-ruby/bin/provenance --in #{t.source} --report artifact_graph > #{t.name}"
end
rule '.report' => '.xml' do |t|
  sh "provenance-ruby/bin/provenance --in #{t.source} --report textual > #{t.name}"
end

task 'imgclean' do
  rm_rf Dir.glob "#{Resources}**/*.*jpeg"
  rm_rf Dir.glob "#{Resources}**/*.cmap"
end

task 'reportclean' do
  rm_rf Dir.glob "#{Resources}**/*.report"
end

task 'dotclean' do
  rm_rf Dir.glob "#{Resources}**/*.dot"
end

Pages.each do |code|
  file "#{resourcepath(code)}#{code}.xml"
  
  file "#{resourcepath(code)}#{code}.dot" => "#{resourcepath(code)}#{code}.xml"
  file "#{resourcepath(code)}#{code}.report" => "#{resourcepath(code)}#{code}.xml"
  Scales.each do |s|
    file "#{resourcepath(code)}#{code}.#{s}cmap" => "#{resourcepath(code)}#{code}.dot"
    file "#{resourcepath(code)}#{code}.#{s}jpeg" => "#{resourcepath(code)}#{code}.dot"
  end
end