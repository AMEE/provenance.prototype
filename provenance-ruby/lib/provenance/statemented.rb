module Prov
  module Statemented
    include RDF
    include Multiloop
    def parse_all(*args,&block)
      all(*args.map{|x| Parser[x]},&block)
    end

    def each_substatement(s,v,o)
      parse_all(s,v,o) do |ss,vv,oo|
        unless ss&&vv&&oo
          $log.warn("Bad statement #{ss},#{vv},#{oo})")
        else
          yield Statement.new(ss,vv,oo)
        end
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

    def label(o=respond_to?(:args) ? args.first : nil,l=o.to_s.split(/\//)[-1])
      # we draw the distinction between auto and manual labels
      # so that manual label can be used for preference
      # if only some accounts give a manual label
      if respond_to?(:args)&&args[1]=="called"
        statement o,OPM.label,RDF::Literal.new(args[2])
        statement o,AMEE.manuallabel,RDF::Literal.new(args[2])
      elsif o=~/"amee:"/
        statement o,OPM.label,RDF::Literal.new(args[1].gsub("amee:",''))
        statement o,AMEE.autolabel,RDF::Literal.new(args[1].gsub("amee:",''))
      else
        statement o,OPM.label,RDF::Literal.new(l)
      end

    end

    module_function :each_substatement, :enum_substatement, :parse_all, :all
  
  end
end