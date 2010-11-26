require 'cgi'
task :default => ["web"]

Resources="Resources/"
Scales=[nil,1,2,4,8]

def resourcepath(code)
  rp=case CGI.unescape(code)
  when /-i [A-Z][A-Z]-\d*/
    "jira"
  when "-b"
    "everything"
  when /--category-subgraph/
    "categories"
  when /--category \//
    "textual_accounts"
  else
    "others"
  end
  result="#{Resources}#{rp}/#{code}/"
  return result
end

def topartial(code)
  "_"+code.gsub('+','_').gsub('%','__').gsub('-','_')
end

def provopts(code)
  CGI.unescape(code)
end

task :clean => [:xmlclean, :dbclean, 
  :imgclean, :dotclean, :reportclean, :webclean]

Pages=[ "-x -i ST-50",
  "-x -i SC-47",
  "-x --category /transport/car/generic/ghgp/us",
  "-b",
  "--database sesame-sparql -b --category-subgraph /transport/car/generic/ghgp/us"
].map{|x|CGI.escape x}