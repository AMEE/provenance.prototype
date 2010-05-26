class AMEE < RDF::Vocabulary("http://xml.amee.com/provenance#")
  property :test
  property :via
  property :browser
end

class OPM < RDF::Vocabulary("http://openprovenance.org/ontology#")
  property :cause
  property :effect
  property :process
  property :wasGeneratedBy
  property :wasDerivedFrom
  property :role
end