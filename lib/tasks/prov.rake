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

def topartial(code)
  "_"+code.downcase.gsub(/-/,'')
end

def prepareticket(code)
  file "#{Resources}#{code}.xml"
  file "#{Resources}#{code}.cmap" => "#{Resources}#{code}.dot"
  file "#{Resources}#{code}.jpeg" => "#{Resources}#{code}.dot"
  file "#{Resources}#{code}.dot" => "#{Resources}#{code}.xml"
  file "#{Resources}#{code}.report" => "#{Resources}#{code}.xml"

  file "app/views/map/#{topartial(code)}.erb" =>
    ["#{Resources}#{code}.cmap"] do
    sh "cp #{Resources}#{code}.cmap app/views/map/#{topartial(code)}.erb"
  end

  file "app/views/report/#{topartial(code)}.erb" =>
    ["#{Resources}#{code}.report"] do
    sh "cp #{Resources}#{code}.report app/views/report/#{topartial(code)}.erb"
  end

  file "public/images/#{code}.jpeg" => ["#{Resources}#{code}.jpeg"] do
    sh "cp #{Resources}#{code}.jpeg public/images/#{code}.jpeg"
  end

  task :web => ["app/views/map/#{topartial(code)}.erb","app/views/report/#{topartial(code)}.erb","public/images/#{code}.jpeg"]
end

prepareticket "ST-50"
prepareticket "SC-47"