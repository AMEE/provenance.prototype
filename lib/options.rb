module Options
  attr_accessor :options
  def parse_options(args)
    args=Shellwords.shellwords(args) if args.class==String
    @options = OpenStruct.new
    options.verbosity=Log4r::INFO
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
    end.parse!(args)
    Log4r::Outputter['stderr'].level=options.verbosity
    $log.debug('Provenance started')
    $log.info("Verbosity #{Log4r::LNAMES[options.verbosity]}")
  end
end