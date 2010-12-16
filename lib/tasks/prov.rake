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


AccountYaml=YAML.load_file(File.join(File.dirname(
       File.dirname(File.dirname(__FILE__))),'config','accounts.yml'))

categories=AccountYaml['categories']
jiras=AccountYaml['jira']

Pages=[
  "-b",
  "-x --sources"
].concat(categories.map{|x|"-x --category #{x}"}).
  concat(categories.map{|x|"--database sesame-sparql -b --category-subgraph #{x}"}).
  concat(jiras.map{|x| "-x -i #{x[0]}-#{x[1]}"}).
  map{|x|CGI.escape x}