require 'jira4r'

# module for connecting to external services
# i.e. Jira, Sesame.

module Connection
  module Jira
    Config=config('jira')
    def self.connect
      @jira ||= begin
        j=Jira4R::JiraTool.new(2, Config['url'])
        p "Authenticating to #{Config['url']} as #{Config['user']}, with #{Config['password']}"
        j.login(Config['user'], Config['password'])
        j
      end
    end
  end
end