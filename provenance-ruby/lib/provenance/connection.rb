module Prov
  # make JiraTool tell us the URL it was made from for later
  Jira4R::JiraTool.class_eval do
    attr_reader :base_url
  end

  # module for connecting to external services
  # manages auth, config files etc.
  # i.e. Jira, Sesame.

  module Connection
    module Jira
      Config=Utils.config('jira')
      def self.connect
        if @jira
          begin
            jira.getIssue("EX-1")
          rescue
            $log.info "Jira connection was dead, reauthenticating"
            @jira=nil
          end
        end
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
      Config=Utils.config('sesame')

      def self.connect
        @sesame ||= begin
          url = RDF::URI.new(Config['url'])
          $log.info "Connecting to #{Config['url']} repository #{Config['repository']}."
          serv = RDF::Sesame::Server.new(url)
          repo = serv.repository(Config['repository'])
          Log4r::Logger['Semantic'].info("Sesame has #{repo.size} existing statements")
          repo
        end
      end
      def self.sparqlurl
        "#{RDF::URI.new(Config['url'])}/repositories/#{Config['repository']}"
      end
    end
  
    module Sparql
      # connect to a SPARQL endpoint.
      Config=Utils.config('sparql')
      def self.connect
        @sparql ||= begin
          url = RDF::URI.new(Config['url'])
          $log.info "Connecting to #{Config['url']} repository "+
            "as a read-only SPARQL endpoint."
          repo = SPARQL::Client::Repository.new(url)
          count=repo.size
          Log4r::Logger['Semantic'].info("Sparql endpoint has #{count} existing statements")
          repo
        end
      end
    end

    module Subversion
      Config=Utils.config('svn')
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
end