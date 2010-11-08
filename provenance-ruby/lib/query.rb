# execute queries against repositories formed of the @triples

module QueryTemplate 
  include RDF
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

  def q(&block)
    query RDF::Query.new(&block)
  end

  delegate :query,:first,:first_subject,:first_object,:first_predicate,
    :to => :repository
end