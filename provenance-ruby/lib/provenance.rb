require 'rubygems'
require 'yaml'
require 'pp'
require 'cgi'
require 'rdf'
require 'rdf/sesame'
#gem 'rdf-raptor','=0.3.0'
require 'rdf/raptor'
require 'sparql/client'
gem 'activesupport','=2.3.8'
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
require 'enumerator'
require 'svn/client'
require 'svn_wc'

require 'patch_sesame'
require 'patch_jira'
#require 'patch_rdf' <-- not needed with 0.4 & greater

require 'utils'
require 'vocabulary'
require 'parser'
require 'multiloop'
require 'statemented'
require 'prov_block'

require 'connection'
require 'comment'
require 'text_file'
require 'svn_file'
require 'text_step'
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
    @project,@issue=Issue.parse_key(options.target)
    @triples=[]
    @db="SemanticDB::#{options.db}".constantize.new
  end


  def jiraread
    if options.jira
      $log.info("Reading from Jira")
      if comment&&issue
        comments=[Comment.new(Connection::Jira.connect,project,issue,comment)]
      elsif issue
        comments=Issue.new(Connection::Jira.connect,project,issue).comments
      else
        # slurp according to filter
        jira=Connection::Jira.connect
        comments=[]
        # our version of jira doesn't paginate here.
        issues=jira.getIssuesFromTextSearch('prov')
        $log.info("Found #{issues.length} issues")
        issues.each do |issue|
          tc=Issue.new(jira,*Issue.parse_key(issue.key)).comments
          $log.info("Found #{tc.length} comments in issue #{issue.key}")
          comments<<tc
        end
        comments.flatten!(1)
      end
      $log.info("Found #{comments.length} comments")
      @blocks=comments
    end
  end

  def handle_prov_blocks(pbs)
    pbs.each do |comment|
      comment.triples.each do |statement|
        @triples << statement
      end
    end
    Parser.context pbs.first.graph_uri # there's only one graph
    pbs.each do |ac|
      statement(ac.graph_uri,OPM.hasAccount,ac.account_uri)
      statement(ac.graph_uri,RDF.type,OPM.OPMGraph)
      statement(ac.account_uri,RDF.type,OPM.Account)
    end
    
    [AMEE.browser,AMEE.via,AMEE.output,
      AMEE.input,AMEE.container,AMEE.numeric].each do |role|
      statement(role,RDF.type,OPM.Role)
      statement(role,OPM.value,role.qname[1].to_s)
    end
  end

  def db_fetch
    if options.db_fetch
      $log.info("Reading from DB")
      @triples=db.fetch
    end
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
    end
    if options.infile
      $log.info("Reading prov:commands from #{options.infile}")
      t=TextFile.new(options.infile)
      steps=t.steps
      $log.info("Found #{steps.length} comments")
      @blocks=steps
    end
    if options.category
      @blocks=[]
      $log.info("Reading prov:commands from #{options.category} in svn")
      svn=Connection::Subversion.connect
      glob=options.recursive ? '**/*.prov' : '*.prov'
      fullpath=File.join(Connection::Subversion::Config['svn_repo_working_copy'],
        options.category,glob)
      accounts=Dir.glob(fullpath).map{|x|
        x.sub(Connection::Subversion::Config['svn_repo_working_copy'],'')}
      $log.info("Found #{accounts.length} accounts: #{accounts.inspect}")
      accounts.each do |account|
        t=SvnFile.new(svn,account)
        steps=t.steps
        $log.info("Found #{steps.length} comments in an account")
        @blocks<<steps
      end
      @blocks.flatten!(1)
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
    jiraread
    db_fetch

    handle_prov_blocks @blocks if @blocks
   
    $log.debug("Before uniq, #{triples.count} triples")
    @repository=Repository.new.insert(*triples)
    @triples=repository.statements #dedup
    $log.info("Found #{triples.count} triples")
    
    db_commit
    file_output
    puts doquery if options.query
  
  end
  def clean
    @blocks=nil
    @triples=[]
    @repository=nil
  end
end