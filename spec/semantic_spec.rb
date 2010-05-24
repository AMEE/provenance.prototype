
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

Triples=[
  RDF::Statement.new(
    RDF::URI(
      "http://jira.amee.com/browse/ST-49?focusedCommentId=12470"),
    RDF::URI(
      "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"),
    AMEE::test
  )
]

describe Semantic do
  before(:each) do
    @semantic=Semantic::Sesame.new
  end

  it "should desc" do
    @semantic.store Triples
    @semantic.true?(Triples[0]).should be_true
    @semantic.delete Triples
  end
end

