module Prov
  
  def parse(name,&block)
    klass=Parser.const_set(name.to_s.classify,Class.new(Parser))
    klass.send(:define_method,:handle,block)
    klass.new
  end

  def prefix(name,&block)
    klass=Parser.const_set(name.to_s.classify,Class.new(PrefixParser))
    klass.send(:define_method,:handle,block)
    klass.new(name)
  end
  module_function :parse,:prefix

  class Parser
  
    def self.[](val)
      val=[val] unless val.class==Array
      @@parsers.each do |v|
        passresult=[]
        val.each do |vval|
          $log.debug("Parsing  #{vval.class} #{vval.inspect} under handler #{v.class}")
          res=v.dohandle(vval)
          if res.class==Array
            res.each do |r|
              passresult<<r
            end
          else
            passresult << res
          end
        end
        val=passresult
      end
      return val
    end
  
    @@parsers=[]
    @@context="http://xml.amee.com/provenance/global" # the context for anonymous URLs
    def self.context(c=@@context)
      @@context=c
    end

    def dohandle(input)
      handle(input)
    end

    def initialize
      @@parsers.push self
    end

  end

  class PrefixParser < Parser
    attr_reader :prefix
    def initialize(prefix)
      @prefix=prefix.to_s
      super()
    end
    def dohandle(input)
      if input=~/#{prefix}\:/
        super
      else
        input
      end
    end
    def presub(input,replacement)
      input.sub(/#{prefix}\:/,replacement)
    end
  end
  
end

