module Statemented
  include RDF
  include Multiloop
  def parse(*args,&block)
    all(*args.map{|x| Parser[x]},&block)
  end

  def statement(s,v,o)
    parse(s,v,o) do |ss,vv,oo|
     triple= Statement.new(ss,vv,oo)
     $log.debug("Created statement #{triple}")
     @triples << triple
    end
  end
end