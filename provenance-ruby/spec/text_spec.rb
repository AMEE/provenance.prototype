require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TextFile do
  it "should load steps" do
    @file=File.new "#{Resources}/something.prov"
    @issue=TextFile.new(@file)
    @issue.steps[0].body.should match 'Mock body'
    @issue.steps.length.should eql 2
  end
  it "should parse commands" do
    @file=File.new "#{Resources}/sample_account.prov"
    @issue=TextFile.new(@file)
    @issue.steps.length.should eql 6
    @typeassertion= @issue.steps[0].commands[0].triples[0]
    @typeassertion.subject.should eql RDF::URI(
      "file:///home/jamespjh/Private/amee/provenance/provenance-ruby/spec"+
        "/resources/sample_account.prov?offset=0#1")
    @typeassertion.predicate.should eql RDF.type
    @typeassertion.object.should eql OPM.WasGeneratedBy
  end
end
