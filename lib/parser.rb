def parse(name,&block)
  klass=Parser.const_set(name.to_s.classify,Class.new(Parser))
  klass.send(:define_method,:handle,block)
  klass.new
end

class Parser
  
  def self.[](val)
    @@parsers.each do |v|
      $log.debug("Parsing #{val} under handler #{v.class}")
      val=v.handle(val)
    end
    val
  end
  
  @@parsers=[]
  
  def handle(input)
    parse(input)
  end

  def initialize
    @@parsers.push self
  end

  require 'parsers'
  
end

