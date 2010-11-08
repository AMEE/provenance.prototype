module Statemented
  include RDF
  include Multiloop
  def parse_all(*args,&block)
    all(*args.map{|x| Parser[x]},&block)
  end

  def each_substatement(s,v,o)
    parse_all(s,v,o) do |ss,vv,oo|
     yield Statement.new(ss,vv,oo)
    end
  end

  def enum_substatement(s,v,o)
    enum_for(:each_substatement,s,v,o)
  end

  def statement(s,v,o)
    each_substatement(s,v,o) do |triple|
      $log.debug("Created statement #{triple}")
      @triples << triple
    end
  end
end