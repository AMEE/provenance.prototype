
module Commands
  # base class corresponding to a provenance command 
  class Command
    include RDF
    def initialize(comment,*args)
      @comment=comment
      @args=args
      @triples=[]
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
    attr_reader :comment,:args,:triples,:subject
  end

  class Test < Command
    def describe
      type AMEE.test
    end
  end
end