class Comment
  attr_reader :commands,:jira,:project,:ticket,:comment,:body
  def initialize(jira,project,ticket,comment)
    # looks up comment , e.g. EX-74 comment 12345 in JIRA,
    # and builds the set of provenance
    # commands it contains
    # note comment id is unique, but we give project and ticket to constructor
    # as well, to help keep URLs meaningful
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

  def parse_body
    # commands are bounded by prov:foo, on newline and semicolon
    # pain to do this in ruby 1.8 without lookaround to do non-consuming splits

    lines=body.split(/[;\n]/)
    # tokenize on whitespace
    lines.each do |line|
      $log.debug "Parsing #{line}"
      tokens=line.split(/\s/)
      reset_parser
      tokens.each do |token|

        if token=~/prov\:/
          cname=token.sub(/prov\:/,'')
          command if @command
          @command=cname
        else
          @args.push token if @command
        end
      end
      command if @command
    end

  end

  def reset_parser
    @command=nil
    @args=[]
  end

  def command
    @commands.push(Command.create(self,@command,@args))
    reset_parser
  end

  def url
    # url of the jira comment
    "#{jira.base_url}/browse/#{project}-#{ticket}?focusedCommentId=#{comment}"
  end

  def uri
    RDF::URI url
  end
end
