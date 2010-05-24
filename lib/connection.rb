require 'jira4r'

# module for connecting to external services
# i.e. Jira, Sesame.

module Connection
  module Jira
    Config=YAML.load_file File.join(File.dirname(File.dirname(__FILE__)),'config','jira.yml')
    def self.connect
      @jira ||= begin
        pp Config
        j=Jira4R::JiraTool.new(2, Config['url'])
        p "Authenticating to #{Config['url']} as #{Config['user']}, with #{Config['password']}"
        j.login(Config['user'], Config['password'])
        j
      end
    end
  end
end