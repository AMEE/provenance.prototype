# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
include Statemented

describe Command do 

  it "should create a test command" do
    @comment=flexmock(:uri=>RDF::URI('http://test.amee.com/jira/EX-7'),
      :account_uri=>nil,:label=>nil)
    @test=Command::Test.new(@comment,'dummy')
    @test.args.should eql ['dummy']
    @test.triples[0].predicate.should eql RDF::URI(
      "http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
    @test.triples[0].subject.should eql RDF::URI('http://test.amee.com/jira/EX-7')
  end
  it "should create an ameem command" do

    @comment=flexmock(:uri=>RDF::URI('http://test.amee.com/jira/EX-7'),
      :graph_uri=>RDF::URI('http://test.amee.com/jira/EX-7/graph'),
      :project=>'EX',:issue=>'7',:ticket=>flexmock,
      :account_uri=> RDF::URI('http://test.amee.com/jira/EX-7/issue'),
      :newuri => RDF::URI('http://test.amee.com/jira/EX-7/new'),
      :comment=>'50',
      :label=>nil)
    @test=Command::Ameem.new(@comment,'dummy')
    @test.triples.should include enum_substatement(
      "amee:dummy",RDF.type,Prov::AMEE.category).to_a.first
  end
end

