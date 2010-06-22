# execute queries against repositories formed of the @triples
# no sparql cos no sparql on rdf library

module QueryTemplate
  def query
    template=ERB.new(options.query)
    template.result(binding)
  end
end