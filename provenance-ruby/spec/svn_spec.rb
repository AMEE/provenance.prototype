require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe 'connection to svn' do
  it "should find and parse an account" do
    @p=Provenance.new("-x --category #{SubversionTestCategory}")
    @p.exec
    @typeassertion= @p.triples[0]
    @typeassertion.subject.should eql RDF::URI(
      "http://svn.amee.com/internal/api_csvs"+
        "/transport/car/generic/ghgp/light.prov?offset=0#1")
    @typeassertion.predicate.should eql RDF.type
    @typeassertion.object.should eql OPM.WasGeneratedBy
  end
end

