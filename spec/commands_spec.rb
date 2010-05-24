# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Commands do 

  it "should create a test command" do
    @comment=flexmock
    @test=Commands::Test.new(@comment,'dummy')
    @test.args.should eql ['dummy']
    @test.triples[0].predicate.should eql RDF::URI(
      "http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
  end
end

