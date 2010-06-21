# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Command do 

  it "should create a test command" do
    @comment=flexmock(:uri=>RDF::URI('http://test.amee.com/jira/EX-7'),:issue_uri=>nil)
    @test=Command::Test.new(@comment,'dummy')
    @test.args.should eql ['dummy']
    @test.triples[0].predicate.should eql RDF::URI(
      "http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
    @test.triples[0].subject.should eql RDF::URI('http://test.amee.com/jira/EX-7')
  end
end

