module Prov
  class Issue
    attr_reader :jira,:project,:ticket
    def initialize(jira,project,ticket)
      # looks up issue , e.g. EX-74 in JIRA,
      @project=project
      @ticket=ticket
      $log.debug("Looking up issue #{key}")
      @jiramodel=jira.getIssue(key)
      @jira=jira
    end

    def self.parse_key(target)
      match=target.match(/([A-Z]+)-([0-9]+)/) if target
      if match
        (project,issue)=match.captures
        issue=issue.to_i
      else
        project=target
        issue=nil
      end
      [project,issue]
    end

    def key
      "#{project}-#{ticket}"
    end

    def comments
      $log.debug("Getting comments for issue #{key}")
      @comments||= begin
        comments=@jira.getComments(key)
        comments.map{|c|Comment.new(@jira,project,ticket,c.id)}
      end
    end

    def uri
      url
    end

    def url
      # url of the jira comment
      "#{jira.base_url}/browse/#{key}"
    end

  end
end