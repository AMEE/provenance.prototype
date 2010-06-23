task :default => ["web"]

Resources="resources/"
Grapher="dot -Gsize=256,4 -Gratio=fill"

rule  '.dot' => '.xml' do |t|
  sh "provenance-java/target/appassembler/bin/ameeopm #{t.source}"
end
rule '.report' => '.xml' do |t|
  sh "provenance-ruby/bin/provenance --in #{t.source} -q #{Resources}textual_report.erb > #{t.name}"
end
rule '.cmap' => '.dot' do |t|
  sh "cat  #{t.source} | #{Grapher} -Tcmap  -o#{t.name}" 
end
rule '.jpeg' => '.dot' do |t|
  sh "cat  #{t.source} | #{Grapher} -Tjpeg -Nfontcolor=blue -o#{t.name}" 
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

file "#{Resources}ST-50.xml"
file "#{Resources}ST-50.cmap" => "#{Resources}ST-50.dot"
file "#{Resources}ST-50.jpeg" => "#{Resources}ST-50.dot"
file "#{Resources}ST-50.dot" => "#{Resources}ST-50.xml"
file "#{Resources}ST-50.report" => "#{Resources}ST-50.xml"

file "app/views/map/_st50.erb" => 
  ["#{Resources}ST-50.cmap"] do
  sh "cp #{Resources}ST-50.cmap app/views/map/_st50.erb" 
end

file "app/views/report/_st50.erb" =>
  ["#{Resources}ST-50.report"] do
  sh "cp #{Resources}ST-50.report app/views/report/_st50.erb"
end

file "public/images/ST-50.jpeg" => ["#{Resources}ST-50.jpeg"] do
  sh "cp #{Resources}ST-50.jpeg public/images/ST-50.jpeg"
end

task :web => ["app/views/map/_st50.erb","app/views/report/_st50.erb","public/images/ST-50.jpeg"]
