class Comment
  attr_reader :commands,:jira,:project,:ticket,:comment,:body
  def initialize(jira,project,ticket,comment)
    # looks up comment , e.g. EX-74 comment 12345 in JIRA,
    # and builds the set of provenance
    # commands it contains
    # note comment id is unique, but we give project and ticket to constructor
    # as well, to help keep URLs meaningful
    @body=jira.getComment(comment).body
    @commands=[]
    @project=project
    @ticket=ticket
    @comment=comment
    @jira=jira
    $log.debug("Parsing comment #{project}-#{ticket}:#{comment}")
    @commands.push(Command.create(self,'test','hello'))
  end
  def url
    # url of the jira comment
    "#{jira.base_url}/browse/#{project}-#{ticket}?focusedCommentId=#{comment}"
  end
  def uri
    RDF::URI url
  end
end
