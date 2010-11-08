
def prov(name,&block)
  klass=Command.const_set(name.to_s.capitalize,Class.new(Command))
  klass.send(:define_method,:do_description,block)
end

class Command
  include RDF
  include Statemented
  def initialize(prov_block,*args)
    @prov_block=prov_block
    @triples=[]
    @subject=prov_block.uri # by default, assume the URI subject for the command
    # is the URL of the prov_block, i.e. the URI for the process
    $log.debug("Building triples for #{self.class}(#{args.join(',')})")
    Parser.context prov_block.account_uri
    parse_all(*args) do |params|
      @args=params
      do_description
    end
    qualify OPM.account,prov_block.account_uri
  end
  
  def qualify(v,o)
    o=RDF::Literal(o.to_s,:datatype=>XSD.anyURI) if v==OPM.type
      # I don't understand this design choice, but OPM types are NOT URIrefs.
      # They're literal values of URI type.
    statement(subject,v,o)
    case v
    when OPM.cause,OPM.effect
      # add to the list of artifacts
      # this would be cleaner done by ontological inferences
      # maybe move this to later sparql
      if o==prov_block.uri
        statement(graph,OPM.hasProcess,o) # these duplicate triples
        statement(o,RDF.type,OPM.Process) # already asserted against the process
        statement(o,OPM.account,prov_block.account_uri) # but safely we make them again
      else
        statement(graph,OPM.hasArtifact,o)
        statement(o,RDF.type,OPM.Artifact)
        statement(o,OPM.label,RDF::Literal.new(o.to_s.split(/\//)[-1]))
        statement(o,OPM.account,prov_block.account_uri)
      end
    end
  end
  def type(o)
    qualify(RDF.type,o)
    case o
      when OPM.Process
        statement graph,OPM.hasProcess,subject
      when OPM.WasDerivedFrom, OPM.WasGeneratedBy,
           OPM.Used, OPM.WasTriggeredBy, OPM.WasControlledBy
        statement graph,OPM.hasDependency,subject
    end
  end
  def graph
    prov_block.graph_uri
  end
  attr_reader :prov_block,:args,:triples
  def subject(s=@subject)
    @subject=s
  end
  def invoke(other_command,nargs=args)
    c="Command::#{other_command.to_s.capitalize}".
      constantize.new(prov_block,*nargs)
    c.triples.each do |s|
      @triples<<s
      end
    subject c.subject
  end
  def self.create(prov_block,name,args)
    $log.debug("Create command #{name.capitalize}(#{args.join(',')})")
    begin
      "Command::#{name.capitalize}".constantize.new(prov_block,*args)
    rescue NameError,ArgumentError => err
      $log.error err
      $log.error err.backtrace
      nil
    end
  end
  Find.find(File.join(File.dirname(__FILE__),'command')) do |file|
    next if File.extname(file) != ".rb"
    require file
  end
end





