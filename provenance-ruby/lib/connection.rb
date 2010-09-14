
# make JiraTool tell us the URL it was made from for later
Jira4R::JiraTool.class_eval do
  attr_reader :base_url
end

# module for connecting to external services
# manages auth, config files etc.
# i.e. Jira, Sesame.

module Connection
  module Jira
    Config=config('jira')
    def self.connect
      @jira ||= begin
        jira=Jira4R::JiraTool.new(2, Config['url'])
        jira.logger=Log4r::Logger['Jira']
        $log.info "Authenticating to #{Config['url']} as #{Config['user']}"
        jira.login(Config['user'], Config['password'])
        jira
      end
    end
  end
  module Sesame
    Config=config('sesame')

    def self.connect
      @sesame ||= begin
        url = RDF::URI.new(Config['url'])
        $log.info "Connecting to #{Config['url']} repository #{Config['repository']}."
        serv = RDF::Sesame::Server.new(url)
        repo = serv.repository(Config['repository'])
        Log4r::Logger['Semantic'].info("#{repo.size} existing statements")
        repo
      end
    end
  end

  module Subversion
    Config=config('svn')
    def self.connect
      @svn ||= begin
        $log.info "Connecting to #{Config['svn_repo_master']} SVN repository"
        wc=SvnWc::RepoAccess.new YAML::dump(Config)
        unless File.directory? Config['svn_repo_working_copy']
          $log.info "Initial checkout to #{Config['svn_repo_working_copy']}"
          wc.do_checkout
        else
          $log.info "Svn updating"
          wc.update
        end
        wc
      end
    end
  end
end