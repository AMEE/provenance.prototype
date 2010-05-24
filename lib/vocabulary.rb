class AMEE < RDF::Vocabulary("http://xml.amee.com/provenance#")
  property :test
end

class OPM < RDF::Vocabulary("http://openprovenance.org/ontology#")
  property :cause
  property :effect
  property :process
  property :was_generated_by
  property :was_derived_from
end