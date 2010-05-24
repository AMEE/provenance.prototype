
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

Triples=[
  RDF::Statement.new(
    RDF::URI(
      "http://jira.amee.com/browse/ST-49?focusedCommentId=12475"),
    RDF::URI(
      "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"),
    AMEE::test
  )
]

describe SemanticDB do
  before(:each) do
    @semantic=SemanticDB::Sesame.new
  end

  it "should store and remove statement" do
    @semantic.true?(Triples[0]).should be_false
    @semantic.store Triples
    @semantic.true?(Triples[0]).should be_true
    @semantic.delete Triples
    @semantic.true?(Triples[0]).should be_false
  end

  it "should handle output of a real comment" do
    @semantic.store Comment.new(Connection::Jira.connect,'ST',49,12470).triples
  end
end
