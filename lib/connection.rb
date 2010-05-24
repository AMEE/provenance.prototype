require 'jira4r'

# module for connecting to external services
# i.e. Jira, Sesame.

module Connection
  module Jira
    Config=YAML.load_file File.join(File.dirname(File.dirname(__FILE__)),'config','jira.yml')
    def self.connect
      @jira ||= begin
        j=Jira4R::JiraTool.new(2, Config[:url])
        j.login(Config[:user], Config[:pass])
        j
      end
    end
  end
end