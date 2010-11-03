module Options
  attr_accessor :options
  def parse_options(args)
    args=Shellwords.shellwords(args) if args.class==String
    @options = OpenStruct.new
    conf=config('prov')
    options.add=true
    options.repeat=false
    options.delete=true
    options.db_fetch=false # fetch from db
    options.out=nil # don't output file format
    options.infile=nil
    options.category=nil
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
      opts.on("-i issue",String) do |issue|
        options.jira=true
        options.target=issue
      end
      opts.on("-p project",String) do |project|
        options.jira=true
        options.target=project
      end
      opts.on("--alljira") do
        options.jira=true
      end
      opts.on("--everything") do
        options.jira=true
        options.category='/'
        options.recursive=true
        options.db_fetch=false
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
      opts.on("-q template", "Execute query template") do |template|
        options.query=File.read template
      end
      opts.on("--sparql template", "Execute sparql query") do |template|
        options.query=File.read template
      end
      opts.on("-o","Output RDFXML to stdout") do
        options.out=:rdfxml
      end
      opts.on("--daemon") do
        options.repeat=true
      end
      opts.on("--in fname","Input RDFXML from file") do |infile|
        options.in=File.new infile
        options.delete=false
        options.add=false
        options.jira=false
        options.db_fetch=false
      end
      opts.on("--file fname","Input amee prov format from file") do |infile|
        options.infile=File.new infile
        options.jira=false
        options.db_fetch=false
      end
      opts.on("--category cpath","Input all prov files from amee api_csvs category") do |cpath|
        options.jira=false
        options.category=cpath
        options.db_fetch=false
      end
      opts.on("--category-recursive cpath","Input all prov files from amee api_csvs category and children") do |cpath|
        options.jira=false
        options.category=cpath
        options.recursive=true
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
    
  end
end