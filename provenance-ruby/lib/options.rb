module Options
  attr_accessor :options
  def parse_options(args)
    args=Shellwords.shellwords(args) if args.class==String
    @options = OpenStruct.new
    conf=config('prov')
    options.add=true
    options.delete=true
    options.jira=true # fetch from jira
    options.db_fetch=false # fetch from db
    options.out=nil # don't output file format
    options.db=conf['db'] ? conf['db'] : "Sesame"
    OptionParser.new do |opts|
      opts.banner = "Usage: provenance [switches] issue"
      opts.separator ""
      opts.separator "Switches:"
      opts.on("-v [verbosity]",Integer) do |verbosity|
        if verbosity
          options.verbosity = verbosity # integer description
        else
          options.verbosity=Log4r::INFO
        end
      end
      opts.on("--verbose verbosity",String) do |verbosity|
        if verbosity
          options.verbosity = "Log4r::#{verbosity.upcase}".constantize
        else
          options.verbosity=Log4r::INFO
        end
      end
      opts.on("--database database",String) do |database|
        options.db=database
        $log.info "Selected database #{database}"
      end
      opts.on("-c comment",Integer) do |comment|
        @comment=comment
      end
      opts.on("-d","delete only") do
        options.add=false
      end
      opts.on("-a","force add only, default replaces") do
        options.delete=false
      end
      opts.on("-x","Don't effect DB, just read data") do
        options.delete=false
        options.add=false
      end
      opts.on("-b","--db_fetch","Don't read ticket, fetch from DB") do
        options.jira=false
        options.db_fetch=true
        options.delete=false
        options.add=false
      end
      opts.on("--clear","empty semantic db") do
        options.jira=false
        options.db_fetch=true
        options.delete=true
        options.add=false
      end
      opts.on("-t", "Don't do anything") do
        options.jira=false
        options.db_fetch=false
        options.delete=false
        options.add=false
      end
      opts.on("-q template", "Execute sparql query template") do |template|
        options.query=File.read template
      end
      opts.on("-o","Output RDFXML to stdout") do
        options.out=:rdfxml
      end
      opts.on("--in fname","Input RDFXML from file") do |infile|
        options.in=File.new infile
        options.delete=false
        options.add=false
        options.jira=false
        options.db_fetch=false
      end
      opts.on("--out format", [:rdfxml,:n3,:ntriples,:turtle], "Output triples to stdout, in 'format'
            (default rdfxml, alternatively n3, turtle, or ntriples)") do |format|
        if format==nil
          options.out=:rdfxml
        else
          options.out=format
        end
      end
    end.parse!(args)
    options.target = args.shift    
  end
end