# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
include Statemented
describe Parser do
  it "Should map http string to a URI" do
    Parser["http://example.com"].first.should be_a RDF::URI
  end
  it "Should parse svn to a URI" do
    Parser["svn:456/example.csv"].first.should be_a RDF::URI
    #removed this tests while i'm not sure how to handle !svn/bc in the graphs
    #Parser["svn:456/example.csv"].first.should eql RDF::URI(
    #  "http://svn.amee.com/!svn/bc/456/example.csv")
    #Parser["svn:6224/internal/api_csvs/business/agriculture/livestock/entericfermentation/sources/V4_10_Ch10_Livestock.pdf"].
    #  first.should eql RDF::URI("http://svn.amee.com/!svn/bc/6224/internal/api_csvs/business/agriculture/livestock/entericfermentation/sources/V4_10_Ch10_Livestock.pdf")
  end
  it "Should parse svn without version number to a URI" do
    Parser["svn:example.csv"].first.should eql RDF::URI("http://svn.amee.com/example.csv")
  end
  it "Should parse apicsvs to URI" do
    Parser["apicsvs:home/energy"].first.
      should eql RDF::URI("http://svn.amee.com/internal/api_csvs/home/energy")
  end
  it "Should parse csv files to several URIs" do
    Parser["csv_files:home/energy/electricity"].
      should eql [
        RDF::URI("http://svn.amee.com/internal/api_csvs/home/energy/electricity/default.js"),
        RDF::URI("http://svn.amee.com/internal/api_csvs/home/energy/electricity/itemdef.csv"),
        RDF::URI("http://svn.amee.com/internal/api_csvs/home/energy/electricity/data.csv")
      ]
  end
  it "Should parse anonymous to context" do
    Parser.context "Happy"
    Parser["anonymous:sad"].should eql ["Happy/sad"]
  end
  it "Should parse out a series of statements" do
    enum_substatement(
      "amee:dummy",RDF.type,Prov::AMEE.category).to_a.
      should eql [Statement.new(RDF::URI("http://live.amee.com/data/dummy"),
        RDF.type,Prov::AMEE.category)]
  end
end

