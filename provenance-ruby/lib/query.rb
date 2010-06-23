# execute queries against repositories formed of the @triples
# no sparql cos no sparql on rdf library

module QueryTemplate 
  include RDF
  def doquery
    template=ERB.new(options.query,nil,'-')
    template.result(binding)
  end
  def link url
    "<a href='#{url}'>#{url}</a>"
  end
  delegate :query,:first,:first_subject,:first_object,:first_predicate,
    :to => :repository
end