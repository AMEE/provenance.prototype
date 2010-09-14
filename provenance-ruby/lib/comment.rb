class Comment < HandlesProvBlock
  include RDF
 
  attr_reader :commands,:jira,:project,:ticket,:comment
  def initialize(jira,project,ticket,comment)
    # looks up comment , e.g. EX-74 comment 12345 in JIRA,
    # and builds the set of provenance
    # commands it contains
    # note comment id is unique, but we give project and ticket to constructor
    # as well, to help keep URLs meaningful
    super()
    $log.debug("Looking up comment #{project}-#{ticket}:#{comment}")
    @body=jira.getComment(comment).body
    @commands=[]
    @project=project
    @ticket=ticket
    @comment=comment
    @jira=jira
    $log.debug("Parsing comment #{project}-#{ticket}:#{comment}")
    parse_body
  end

  def label
    "#{project}-#{ticket} #{comment}"
  end

  def url
    # url of the jira comment
    "#{jira.base_url}/browse/#{project}-#{ticket}?focusedCommentId=#{comment}"
  end

  def account_uri
     "#{jira.base_url}/browse/#{project}-#{ticket}"
  end

  
end
