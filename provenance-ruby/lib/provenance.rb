require 'rubygems'
require 'yaml'
require 'pp'
require 'cgi'
require 'rdf'
require 'rdf/sesame'
require 'rdf/raptor'
require 'sparql/client'
require 'active_support'
require 'jira4r'
require 'find'
require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'shellwords'
require 'log4r'
require 'log4r/yamlconfigurator'
require 'erb'
require 'shellwords'

require 'patch_sesame'
require 'patch_jira'
require 'patch_rdf'

require 'utils'
require 'vocabulary'
require 'parser'
require 'multiloop'
require 'statemented'

require 'connection'
require 'comment'
require 'command'
require 'semantic_db'
require 'options'
require 'issue'
require 'query'


class Provenance
  include RDF
  include Options
  include QueryTemplate
  include Statemented
  attr_reader :project,:issue,:comment,:triples,:db,:repository
  def initialize(args)
    parse_options(args)
    Log4r::Outputter['stderr'].level=options.verbosity if options.verbosity
    $log.debug('Provenance started')
    $log.info("Verbosity #{Log4r::LNAMES[Log4r::Outputter['stderr'].level]}")
    match=options.target.match(/([A-Z]+)-([0-9]+)/) if options.target
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
      @comments=[Comment.new(Connection::Jira.connect,project,issue,comment)]
    else
      @comments=Issue.new(Connection::Jira.connect,project,issue).comments
    end
    $log.info("Found #{@comments.length} comments")
    @comments.each do |comment|
      comment.triples.each do |statement|
        @triples << statement
      end
    end
    Parser.context @comments.first.graph_uri
    statement(@comments.first.graph_uri,OPM.hasAccount,@comments.first.issue_uri)
    statement(@comments.first.graph_uri,RDF.type,OPM.OPMGraph)
    statement(@comments.first.issue_uri,RDF.type,OPM.Account)
    [AMEE.browser,AMEE.via,AMEE.output,
      AMEE.input,AMEE.container,AMEE.numeric].each do |role|
      statement(role,RDF.type,OPM.Role)
      statement(role,OPM.value,role.qname[1].to_s)
    end
  end

  def db_fetch
     $log.info("Reading from DB")
     @triples=db.fetch
  end

  def db_commit
    $log.debug("Before commit, db has #{db.count} triples")
    $log.debug("Operating on #{triples.length} triples")
    db.delete triples if options.delete
    db.store triples if options.add
    $log.debug("After commit, db has #{db.count} triples")
  end

  def file_input
    if options.in
      $log.info("Reading rdfxml statements from #{options.in}")
      RDF::Reader.for(:rdfxml).new(options.in) do |reader|
          reader.each_statement do |s|
            triples<<s
          end
      end
      @repository=Repository.new.insert(*triples)
    end
  end

  def file_output
    if options.out
      $log.info("Writing #{triples.length} stements as #{options.out} to stdout")
      case options.out
      when :rdfxml,:ntriples,:turtle
        RDF::Writer.for(options.out).new do |writer|
          triples.each do |statement|
            $log.debug("Writing triple #{statement}")
            writer<<statement
            writer.flush_pipe if writer.respond_to? :flush_pipe
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
   file_input
   if options.jira
      jiraread
      $log.debug("Before uniq, #{triples.count} triples")
      @repository=Repository.new.insert(*triples)
      @triples=repository.statements
    elsif options.db_fetch
      db_fetch
      @repository=Repository.new.insert(*triples)
    end
    $log.info("Found #{triples.count} triples")  
    db_commit
    file_output
    puts doquery if options.query
  
  end
  def clean
    
  end
end