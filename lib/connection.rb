require 'jira4r/jira4r'

# module for connecting to external services
# i.e. Jira, Sesame.

module Connection
  JiraConfig=YAML.load 'jira.yml'
  def jira
    @jira ||= begin
      j=Jira::JiraTool.new(2, JiraConfig.url)
      j.login(JiraConfig.user, JiraConfig.pass)
      j
    end
  end
end