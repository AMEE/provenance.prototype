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
require 'patch_sesame'

require 'utils'
require 'vocabulary'
require 'parser'

require 'connection'
require 'comment'
require 'command'
require 'semantic_db'
require 'options'
require 'issue'


class Provenance
  include Options
  attr_reader :project,:issue,:comment
  def initialize(args)
    parse_options(args)
    Log4r::Outputter['stderr'].level=options.verbosity if options.verbosity
    $log.debug('Provenance started')
    $log.info("Verbosity #{Log4r::LNAMES[Log4r::Outputter['stderr'].level]}")
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
    if comment
      comments=[Comment.new(Connection::Jira.connect,project,comment)]
    else
      comments=Issue.new(Connection::Jira.connect,project,issue).comments
    end
    $log.info("Found #{comments.length} comments")
    db="SemanticDB::#{options.db}".constantize.new
    $log.debug("Before commit, #{db.count} assertions")
    if options.delete
      # delete currently removes all the literal current triples in the ticket/comment
      # this is of course stupid
      # it needs instead to delete the triples which reference the ticket/comment URIs as subjects
      comments.each do |comment|
        db.delete comment.triples
      end
    end
    if options.add
      comments.each do |comment|
        db.store comment.triples
      end
    end
    $log.debug("After commit, #{db.count} assertions")
  end
  def clean
    
  end
end