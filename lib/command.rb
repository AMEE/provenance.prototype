
module Commands
  # base class corresponding to a provenance command 
  class Command
    include RDF
    def initialize(comment,*args)
      @comment=comment
      @args=args
      @triples=[]
      @subject=comment.uri # by default, assume the URI subject for the command
      # is the URL of the comment, i.e. the URI for the process
      $log.debug("Building #{self.class}(#{args})")
      describe
    end
    def statement(s,v,o)
      @triples << Statement.new(s,v,o)
    end
    def qualify(v,o)
      statement(subject,v,o)
    end
    def type(o)
      qualify(RDF.type,o)
    end
    attr_reader :comment,:args,:triples
    attr_accessor :subject
  end

  class Test < Command
    def describe
      type AMEE.test
    end
  end
end