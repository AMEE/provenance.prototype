require 'rubygems'
require 'yaml'
require 'pp'
require 'cgi'
require 'rdf'
require 'rdf/sesame'
require 'sparql/client'
#gem 'rdf-raptor','=0.3.0'
require 'rdf/raptor'
require 'sparql/client'
gem 'activesupport','~>2.3.9'
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

require 'ameem'

require 'provenance/patch_sesame'
require 'provenance/patch_jira'
#require 'patch_rdf' <-- not needed with 0.4 & greater

require 'provenance/utils'

require 'provenance/vocabulary'
require 'provenance/parser'
require 'provenance/parsers'
require 'provenance/multiloop'
require 'provenance/statemented'
require 'provenance/prov_block'
require 'provenance/crawler'

require 'provenance/connection'
require 'provenance/comment'
require 'provenance/text_file'
require 'provenance/svn_file'
require 'provenance/text_step'
require 'provenance/legacy'
require 'provenance/command'

Find.find(File.join(File.dirname(__FILE__),'provenance','command')) do |file|
  next if File.extname(file) != ".rb"
  require file
end

require 'provenance/options'
require 'provenance/issue'
require 'provenance/query'

module Prov
  class Provenance
    include RDF
    include Utils
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
      @db=case options.db.downcase
      when 'sesame'
        Connection::Sesame.connect
      when 'sesame-sparql'
        Connection::Sparql.connect
      else
        raise "No such db as #{options.db}"
      end
    end


    def jiraread
      if options.jira
        $log.info("Reading from Jira")
        if comment&&issue
          handle_prov_block Comment.new(Connection::Jira.connect,project,issue,comment)
        elsif issue
          Issue.new(Connection::Jira.connect,project,issue).
            comments.each do |c|
            handle_prov_block c
          end
        else
          # slurp according to filter
          jira=Connection::Jira.connect
          # our version of jira doesn't paginate here.
          issues=jira.getIssuesFromTextSearch('prov')
          $log.info("Found #{issues.length} issues")
          issues.each do |issue|
            tc=Issue.new(jira,*Issue.parse_key(issue.key)).comments
            $log.info("Found #{tc.length} comments in issue #{issue.key}")
            tc.each do |c| handle_prov_block c end
          end
        end
        declare_roles
      end
    end

    def handle_prov_block(pb)
      @triples.concat(pb.triples)
      statement(graph_uri,OPM.hasAccount,pb.account_uri)
      label(pb.account_uri)
      statement(pb.account_uri,RDF.type,OPM.Account)
    end

    def declare_roles
      [AMEE.browser,AMEE.via,AMEE.output,
        AMEE.input,AMEE.container,AMEE.numeric].each do |role|
        statement(role,RDF.type,OPM.Role)
        statement(role,OPM.value,role.qname[1].to_s)
      end
      statement(graph_uri,RDF.type,OPM.OPMGraph)
      Parser.context graph_uri # there's only one graph
    end

    def graph_uri
      AMEE.graph
    end

    def db_fetch
      if options.db_fetch
        $log.info("Reading from DB")
        @repository=db
      end
    end

    def db_commit
      return unless options.delete || options.add
      unless db.mutable?
        $log.warn("Cannot write to immutable repository")
        return
      end
      $log.debug("Before commit, db has #{db.count} triples")
      $log.debug("Operating on #{triples.length} triples")
      db.delete *triples if options.delete
      db.insert *triples if options.add
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
        steps.each do |step|
          handle_prov_block step
        end
      end
      if options.category
        $log.info("Reading prov:commands from #{options.category} in svn")
        glob=options.recursive ? '**/*.prov' : '*.prov'
        svn_block(glob,SvnFile,File.join('api_csvs',options.category)).flatten(1)
      end
      if options.legacy
      
        $log.info("Reading legacy from #{options.legacy} in svn")
      
        dataglob=options.recursive ? '**/data.csv' : 'data.csv'
        metaglob=options.recursive ? '**/meta.yml' : 'meta.yml'
        svn_block(dataglob,DataCsvFile,File.join('api_csvs',options.legacy)).flatten(1)
        svn_block(metaglob,MetaYmlFile,options.legacy).flatten(1)      
      end
      if options.sourcechecker
        $log.info("Reading sourcechecker accounts from SVN")
        svn_block('**/*.prov',SvnFile,'provenance/sourcechecker')
      end
      if options.in||options.infile||options.category||options.legacy||options.sourcechecker
        declare_roles
      end
    end

    def svn_block(glob,klass,folder)
      svn=Connection::Subversion.connect
      fullpath=File.join(Connection::Subversion::Config['svn_repo_working_copy'],
        folder,glob)
      accounts=Dir.glob(fullpath).map{|x|
        x.sub(Connection::Subversion::Config['svn_repo_working_copy'],'')}
      $log.info("Found #{accounts.length} accounts: #{accounts.inspect}")
      accounts.each do |account|
        t=klass.new(svn,account)
        steps=t.steps
        $log.info("Found #{steps.length} comments in an account")
        steps.each do |step|
          handle_prov_block step
        end
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
      
      # different ways of obtaining triples and a repository to work on
      file_input
      jiraread
      db_fetch
      db_query
     
      sparql_query
      

      unless @triples.empty?
        $log.debug("Before uniq, #{triples.count} triples")
        @repository=Repository.new.insert(*triples)
      end
      if options.subgraph
        $log.debug("Crawling repository for #{options.subgraph}")
        c=OPMCrawler.new(@repository,options.subgraph)
        @repository=c.induced_subgraph
      end
    
      @triples=repository.statements.to_a #dedup
      $log.info("Found #{triples.count} triples")
    
      db_commit
      file_output
      puts doquery if options.query
  
    end
    def clean
      @triples=[]
      @repository=nil
    end
  end
end