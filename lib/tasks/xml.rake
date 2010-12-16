rule '.xml' do |t|
  begin
    code=File.basename(t.name,'.xml')
    sh "mkdir -p #{resourcepath(code)}"
    switch=provopts(code)
    sh "provenance-ruby/bin/provenance -o #{switch} > #{t.name}"
  rescue => err
    p "Failed with #{err}, removing partial file"
      rm "#{resourcepath(code)}#{t.name}"
  end
end

task 'xmlclean' do
  rm_rf Dir.glob "#{Resources}**/*.xml"
end

task "categoryclean" do
  rm_rf Dir.glob "#{Resources}/categories/**/*.xml"
end