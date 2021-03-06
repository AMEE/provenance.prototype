
require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

Triples=[
  RDF::Statement.new(
    RDF::URI(
      "http://jira.amee.com/browse/ST-49?focusedCommentId=12475"),
    RDF::URI(
      "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"),
    Prov::AMEE::test
  )
]

describe "Connection to sesame" do
  before(:each) do
    @semantic=Connection::Sesame.connect
  end

  it "should store and remove statement" do
    @semantic.delete *Triples
    bcount=@semantic.count
    @semantic.has_statement?(Triples[0]).should be_false
    @semantic.insert *Triples
    @semantic.count.should eql bcount+1
    @semantic.has_statement?(Triples[0]).should be_true
    @semantic.delete *Triples
    @semantic.has_statement?(Triples[0]).should be_false
    @semantic.count.should eql bcount
  end

  it "should handle output of a real comment" do
    @semantic.insert *Comment.new(Connection::Jira.connect,'ST',49,12470).triples
  end
end

describe "Connection to DB via provenance command" do

  it "should handle db upload provenance command with a real comment" do
    @d=Provenance.new("-d --file #{Resources}/something.prov")
    @d.exec
    @p=Provenance.new("--file #{Resources}/something.prov")
    lambda{@p.exec}.should_not raise_error
  end

  it "should read data from sparql endpoint" do
    @d=Provenance.new("--database sesame-sparql -b")
    lambda{@d.exec}.should_not raise_error
    @d.triples.should_not be_empty
  end

  it "can fetch all the data from the db and put it straight back" do
    @p=Provenance.new("-b")
    lambda{@p.exec}.should_not raise_error
  end
end

