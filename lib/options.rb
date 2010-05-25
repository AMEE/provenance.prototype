module Options
  attr_accessor :options
  def parse_options(args)
    args=Shellwords.shellwords(args) if args.class==String
    @options = OpenStruct.new
    conf=config('prov')
    options.add=true
    options.delete=true
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
      opts.on("-t","Don't effect DB, just read data") do
        options.delete=false
        options.add=false
      end
    end.parse!(args)
    Log4r::Outputter['stderr'].level=options.verbosity if options.verbosity
    $log.debug('Provenance started')
    $log.info("Verbosity #{Log4r::LNAMES[Log4r::Outputter['stderr'].level]}")
    options.target = args.shift
    
    
  end
end