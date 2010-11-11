# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Comment do
  
  it "should create comments from a mock jira" do
    @jira=flexmock(:base_url=>"http://example.com/jira",:getComment=>
      flexmock(:body=>'Mock body prov:test Hopeful'))
    @comment=Comment.new(@jira,'EX',1,55)
    @comment.body.should match 'Mock body'
    @typeassertion= @comment.commands[0].triples[0]
    @typeassertion.predicate.should eql RDF::URI(
      "http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
    @typeassertion.subject.should eql RDF::URI(
      "http://example.com/jira/browse/EX-1?focusedCommentId=55")
    @typeassertion.object.should eql Prov::AMEE::test
  end
  it "shouldn't balk on apostrophes" do
    @jira=flexmock(:base_url=>"http://example.com/jira",:getComment=>
      flexmock(:body=>"Didn't work before prov:test Hopeful"))
    lambda{Comment.new(@jira,'EX',1,55)}.should_not raise_error
    
    @jira=flexmock(:base_url=>"http://example.com/jira",:getComment=>
      flexmock(:body=>"Dogs' bones work before prov:test Hopeful"))
    lambda{Comment.new(@jira,'EX',1,55)}.should_not raise_error
    
    @jira=flexmock(:base_url=>"http://example.com/jira",:getComment=>
      flexmock(:body=>"'bah't 'at prov:test Hopeful"))
    lambda{Comment.new(@jira,'EX',1,55)}.should_not raise_error
  end
  it "should create comments from a real jira" do
    @jira=Connection::Jira.connect
    @sesame=Connection::Sesame.connect
    @comment=Comment.new(@jira,'ST',49,12470)
    @comment.body.
      should match "Example provenance commands to test out the system"
    @typeassertion= @comment.commands[0].triples[0]
    @typeassertion.predicate.should eql RDF::URI(
      "http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
    @typeassertion.subject.should eql RDF::URI(
      "http://jira.amee.com/browse/ST-49?focusedCommentId=12470")
    @typeassertion.object.should eql Prov::AMEE::test
  end
end

