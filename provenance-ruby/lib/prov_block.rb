class HandlesProvBlock

  attr_reader :body,:commands,:triples
  
  def initialize
    @urinum=0
    @commands=[]
  end

  def uri
    RDF::URI url
  end

  def newuri
    @urinum+=1
    RDF::URI "#{url}##{@urinum}"
  end

  def triples
    @commands.map{|x| x.triples}.flatten(1)
  end

  private

    def parse_body
    # commands are bounded by prov:foo and semicolon
    # pain to do this in ruby 1.8 without lookaround to do non-consuming splits

    lines=body.split(/[;]/) # was also on newline, trying without
    # tokenize on whitespace
    lines.each do |line|
      $log.debug "Parsing #{line}"
      begin
        tokens=Shellwords.shellwords(line) # don't split whitespace inside quotes
      rescue ArgumentError
        # robustly try to do the right thing if apostrophe in middle of a word
        line.gsub!(/\w'\w/,'') # handle didn't shouldn't it's cat's etc...
        begin
          tokens=Shellwords.shellwords(line)
        rescue ArgumentError
          line.gsub!(/\w'/,'') # handle dogs'
          begin
            tokens=Shellwords.shellwords(line)
          rescue ArgumentError
            tokens=line.split(' ')
          end
        end
      end
      reset_parser
      tokens.each do |token|
        handle_token(token)
      end
      command if @command
    end

  end

  def handle_token(token)
    if token=~/prov\:/
      cname=token.sub(/prov\:/,'')
      # if there's already a command on this line, we reached end of arguments
      command if @command
      # and regardless of that, we've got a new command to start now.
      @command=cname
    else
      # it's only an arg to a command if we're currently doing a command
      @args.push token if @command
    end
  end

  def reset_parser
    @command=nil
    @args=[]
  end

  def command
    c=Command.create(self,@command,@args)
    @commands.push(c) if c
    reset_parser
  end

end

