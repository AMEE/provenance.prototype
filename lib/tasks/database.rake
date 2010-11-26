
task 'dbclean' do
  sh "provenance-ruby/bin/provenance --clear"
end

task 'dbfill' do
  sh "provenance-ruby/bin/provenance --everything"
end