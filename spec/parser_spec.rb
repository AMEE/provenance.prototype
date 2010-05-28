# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Parser do
  it "Should map http string to a URI" do
    Parser["http://example.com"].should be_a RDF::URI
  end
  it "Should parse svn to a URI" do
    Parser["svn:456/example.csv"].should be_a RDF::URI
    Parser["svn:456/example.csv"].should eql RDF::URI("http://svn.amee.com/!svn/bc/456/example.csv")
  end
end
