def parse(name,&block)
  klass=Parser.const_set(name.to_s.classify,Class.new(Parser))
  klass.send(:define_method,:handle,block)
  klass.new
end

class Parser
  
  def self.[](val)
    val=[val] unless val.class==Array   
    @@parsers.each do |v|
      passresult=[]
      val.each do |vval|
        $log.debug("Parsing  #{vval.class} #{vval.inspect} under handler #{v.class}")
        res=v.handle(vval)
        if res.class==Array
          res.each do |r|
            passresult<<r
          end
        else
          passresult << v.handle(vval)
        end
      end
      val=passresult
    end
    return val
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

