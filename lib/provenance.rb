require 'rubygems'
require 'yaml'
require 'pp'
require 'rdf'
require 'rdf/sesame'
require 'active_support'
require 'jira4r'
require 'find'
require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'shellwords'
require 'log4r'
require 'log4r/yamlconfigurator'

require 'utils'
require 'vocabulary'
require 'connection'
require 'comment'
require 'command'
require 'semantic_db'
require 'options'

class Provenance
  include Options
  attr_reader :project,:issue
  def initialize(args)
    parse_options(args)
    match=options.target.match(/([A-Z]+)-([0-9]+)/)
    if match
      (@project,@issue)=match.captures
      @issue=@issue.to_i
    else
      @project=options.target
      @issue=nil
    end
  end
  def exec
    
  end
  def clean
    
  end
end