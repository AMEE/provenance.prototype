class AMEE < RDF::Vocabulary("http://xml.amee.com/provenance#")
  property :test
  property :via
  property :browser
  property :output
  property :container
  property :input
  property :download
  property :outfolder
end

class OPM < RDF::Vocabulary("http://openprovenance.org/ontology#")
  property :cause
  property :effect
  property :role
  property :account
  property :label
  property :value
  property :type
  property :Process
  property :WasGeneratedBy
  property :WasDerivedFrom
  property :Role
  property :Agent
  property :Account
  property :OPMGraph
  property :Artifact
  property :Used
  property :hasArtifact
  property :hasProcess
  property :hasDependency
  property :hasAccount
  property :hasAgent
end