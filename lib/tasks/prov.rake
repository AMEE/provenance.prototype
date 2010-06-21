task :default => ["web"]

Resources="resources/"

rule  '.dot' => '.xml' do |t|
  sh "provenance-java/target/appassembler/bin/ameeopm #{t.source}"
end

rule '.cmap' => '.dot' do |t|
  sh "fdp -Tcmap -o#{t.name} #{t.source}" 
end
rule '.jpeg' => '.dot' do |t|
  sh "fdp -Tjpeg -o#{t.name} #{t.source}" 
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

file "#{Resources}ST-50.xml"
file "#{Resources}ST-50.cmap" => "#{Resources}ST-50.dot"
file "#{Resources}ST-50.jpeg" => "#{Resources}ST-50.dot"
file "#{Resources}ST-50.dot" => "#{Resources}ST-50.xml"

file "app/views/testmap/_st50.erb" => 
  ["#{Resources}ST-50.cmap"] do
  sh "cp #{Resources}ST-50.cmap app/views/testmap/_st50.erb" 
end

file "public/images/ST-50.jpeg" => ["#{Resources}ST-50.jpeg"] do
  sh "cp #{Resources}ST-50.jpeg public/images/ST-50.jpeg"
end

task :web => ["app/views/testmap/_st50.erb","public/images/ST-50.jpeg"]
