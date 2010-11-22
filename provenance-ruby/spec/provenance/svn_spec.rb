require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')
describe 'connection to svn' do
  it "should find and parse an account" do
    @p=Provenance.new("-x --category #{SubversionTestCategory}")
    @p.exec
    @typeassertion= @p.triples.first
    @typeassertion.subject.should eql RDF::URI(
      "http://svn.amee.com/internal/api_csvs"+
        "/transport/car/generic/ghgp/us/light.prov?offset=0#5")
    @typeassertion.predicate.should eql OPM.account
    @typeassertion.object.should eql RDF::URI(
       "http://svn.amee.com/internal/api_csvs/"+
         "transport/car/generic/ghgp/us/light.prov")
  end
end
