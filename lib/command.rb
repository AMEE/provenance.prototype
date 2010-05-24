
module Commands
  # base class corresponding to a provenance command
  class Command
  def initialize(comment,*args)
    @comment=comment
    @args=args
    $log.debug("#{self.class}(#{args}) created")
  end
  attr_reader :comment,:args
  end

  class Test < Command
    def triples
      
    end
  end
end