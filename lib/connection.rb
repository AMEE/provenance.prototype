require 'jira4r'

# module for connecting to external services
# i.e. Jira, Sesame.

module Connection
  module Jira
    Config=config('jira')
    def self.connect
      @jira ||= begin
        j=Jira4R::JiraTool.new(2, Config['url'])
        j.logger=Log4r::Logger['Jira']
        $log.info "Authenticating to #{Config['url']} as #{Config['user']}"
        j.login(Config['user'], Config['password'])
        j
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
      end
    end
  end
end