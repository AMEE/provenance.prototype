# execute queries against repositories formed of the @triples
module Prov
  module QueryTemplate
    Colors=%w{red blue green orange cyan magenta yellow violet indigo}
    include RDF
    # these methods add support for textual output queries against the repo
    def doquery
      template=ERB.new(options.query,nil,'-')
      template.result(binding)
    end
    def link url
      "<a href='#{url}'>#{url}</a>"
    end
    def l text
      text.to_s.gsub("\n",'\n')
    end
    def q(&block)
      RDF::Query.new(&block).execute(repository)
    end

    def label_for(uriref)
      ol=longest_object([uriref,OPM.label,nil])
      dl=longest_object([uriref,AMEE.autolabel,nil])
      ml=longest_object([uriref,AMEE.manuallabel,nil])
      return narrow((ml||dl||ol||uriref).to_s)
    end

    def longest_object(pattern)
      res=query(pattern).map{|s|s.object}
      res.sort{|x,y|y.to_s.length<=>x.to_s.length}.first
    end

    def color_for(uriref)
      @colors||={}
      return @colors[uriref] if @colors[uriref]
      @colors[uriref]=newcolor
      return @colors[uriref]
    end

    def newcolor
      @colorindex||=-1
      @colorindex+=1
      @colorindex=0 if @colorindex>=Colors.length
      Colors[@colorindex]
    end

    delegate :query,:first,:first_subject,:first_object,:first_predicate,
      :to => :repository

    # these methods support querying db to obtain the triples to be analysed
    def db_query
      if options.db_query
        $log.info("Querying DB for input triples")
        # the query is evaluated as if it was a member function of the db
        @triples=eval(options.db_query,db.instance_eval{binding})
      end
    end

    def sparqler
      # attempt to get a sparql parser for the db repo
      if db.is_a? SPARQL::Client::Repository
        db.client
      elsif db.is_a? RDF::Sesame::Repository
        SPARQL::Client.new(db.url)
      else
        raise "DB not provided in form which can be queried with sparql"
      end
    end

    def sparql_query
      if options.sparql_query
        $log.info("SPARQL Querying DB for input triples")
        @triples=sparqler.query(options.sparql_query).to_a
      end
    end

  
  end
end