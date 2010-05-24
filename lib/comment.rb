class Comment
  attr_reader :commands,:jira,:code
  def initialize(jira,code)
   # looks up code, e.g. EX-74 in JIRA, and builds the set of provenance
   # commands it contains
    @commands=[]
    @code=code
    @jira=jira
    $log.debug("Parsing comment #{code}")
    @commands.push(Commands::Test.new(self,'hello'))
  end
  def url
    # url of the jira comment
    "#{jira.base_url}/browse/#{code}"
  end
  def uri
    RDF::URI url
  end
end
