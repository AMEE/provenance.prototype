
def prov(name,&block)
  klass=Command.const_set(name.to_s.capitalize,Class.new(Command))
  klass.send(:define_method,:describe,block)
end

class Command
  include RDF
    
  def initialize(comment,*args)
    @comment=comment
    @args=args
    @triples=[]
    @subject=comment.uri # by default, assume the URI subject for the command
    # is the URL of the comment, i.e. the URI for the process
    $log.debug("Building triples for #{self.class}(#{args.join(',')})")
    describe
  end
  def statement(s,v,o)
    @triples << Statement.new(Parser[s],Parser[v],Parser[o])
  end
  def qualify(v,o)
    statement(subject,v,o)
    case v
    when OPM.cause,OPM.effect
      # add to the list of artifacts
      # this would be cleaner done by ontological inferences
      # maybe move this to later sparql
      unless o==comment.uri
        statement(graph,OPM.hasArtifact,o)
        statement(o,RDF.type,OPM.Artifact)
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
    comment.graph_uri
  end
  attr_reader :comment,:args,:triples
  def subject(s=@subject)
    @subject=s
  end

  def self.create(comment,name,args)
    $log.debug("Create command #{name.capitalize}(#{args.join(',')})")
    begin
      "Command::#{name.capitalize}".constantize.new(comment,*args)
    rescue NameError,ArgumentError => err
      $log.error err
      #$log.error err.backtrace
      nil
    end
  end
  Find.find(File.join(File.dirname(__FILE__),'command')) do |file|
    next if File.extname(file) != ".rb"
    require file
  end
end





