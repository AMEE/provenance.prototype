class AMEE < RDF::Vocabulary("http://xml.amee.com/provenance#")
  property :test
  property :via
  property :browser
end

class OPM < RDF::Vocabulary("http://openprovenance.org/ontology#")
  property :cause
  property :effect
  property :role
  property :account
  property :label
  property :Process
  property :WasGeneratedBy
  property :WasDerivedFrom
  property :Role
  property :Artifact
  property :Used
end