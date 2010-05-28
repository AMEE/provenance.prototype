require 'rubygems'
require 'yaml'
require 'pp'
require 'rdf'
require 'rdf/sesame'
require 'rdf/raptor'
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
require 'patch_jira'

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
  attr_reader :project,:issue,:comment,:triples,:db
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
    @triples=[]
    @db="SemanticDB::#{options.db}".constantize.new
  end

  def jiraread
    $log.info("Reading from Jira")
    if comment
      comments=[Comment.new(Connection::Jira.connect,project,comment)]
    else
      comments=Issue.new(Connection::Jira.connect,project,issue).comments
    end
    $log.info("Found #{comments.length} comments")
    comments.each do |comment|
      comment.triples.each do |statement|
        @triples << statement
      end
    end
  end

  def db_commit
    $log.debug("Before commit, db has #{db.count} triples")
    if options.delete
      # delete currently removes all the literal current triples in the ticket/comment
      # this is of course stupid
      # it needs instead to delete the triples which reference the ticket/comment URIs as subjects
      comments.each do |comment|
        db.delete triples
      end
    end
    if options.add
      comments.each do |comment|
        db.store triples
      end
    end
    $log.debug("After commit, db has #{db.count} triples")
  end

  def file_output
    if options.out
      $log.info("Writing #{triples.length} stements as #{options.out} to stdout")
      case options.out
      when :rdfxml,:ntriples,:turtle
        RDF::Writer.for(options.out).new do |writer|
          triples.each do |statement|
            writer<<statement
          end
        end
      when :n3
        $log.warn("No N3 compact serialiser - output is ntriples.")
        RDF::Writer.for(:ntriples).new do |writer|
          triples.each do |statement|
            writer<<statement
          end
        end
      end       
    end
  end

  def exec
    
    if options.jira
      jiraread
    elsif options.db_fetch
      $log.info("Reading from DB")
    end
    $log.info("Found #{triples.count} triples")
    
    db_commit
    file_output
  
  end
  def clean
    
  end
end