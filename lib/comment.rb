class Comment
  attr_reader :commands
  def initialize(jira,code)
   # looks up code, e.g. EX-74 in JIRA, and builds the set of provenance
   # commands it contains
    @commands=[]
    @commands.push(Commands::Test.new(self,'hello'))
  end
end
