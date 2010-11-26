
task 'webclean' do
  rm_rf Dir.glob "app/views/map/*.erb"
  rm_rf Dir.glob "public/images/*.*jpeg"
end

Pages.each do |code|
  Scales.each do |s|
    file "app/views/map/#{topartial(code)}#{s}.erb" =>
      ["#{resourcepath(code)}#{code}.#{s}cmap"] do
      sh "cp #{resourcepath(code)}#{code}.#{s}cmap app/views/map/#{topartial(code)}#{s}.erb"
    end
    file "public/images/#{topartial(code)}#{s}.jpeg" => ["#{resourcepath(code)}#{code}.#{s}jpeg"] do
      sh "mkdir -p public/images"
      sh "cp #{resourcepath(code)}#{code}.#{s}jpeg public/images/#{topartial(code)}#{s}.jpeg"
    end
    task :web => ["app/views/map/#{topartial(code)}#{s}.erb","public/images/#{topartial(code)}#{s}.jpeg"]
  end
  file "app/views/report/#{topartial(code)}.erb" =>
    ["#{resourcepath(code)}#{code}.report"] do
    sh "cp #{resourcepath(code)}#{code}.report app/views/report/#{topartial(code)}.erb"
  end

 
  task :web => ["app/views/report/#{topartial(code)}.erb"]
end