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

class Provenance
  def initialize(args)
    args=Shellwords.shellwords(args) if args.class==String
    @options = OpenStruct.new
  end
  def exec
    
  end
  def clean
    
  end
end