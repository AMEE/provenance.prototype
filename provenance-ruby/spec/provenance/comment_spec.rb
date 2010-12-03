require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

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
    @comment=Comment.new(@jira,'SC',47,14135)
    @comment.author.should eql 'james.hetherington'
    @triples= @comment.commands.collect{|c| c.triples}.flatten(1)
    dpath="transport/car/generic/ghgp/us"
    [
      [@comment.uri,RDF.type,OPM.Process],
      ["amee:#{dpath}",RDF.type,Prov::AMEE.category],
      [@comment.uri+"#1",OPM.cause,"apicsvs:#{dpath}/default.js"],
      [@comment.uri+"#2",OPM.cause,"apicsvs:#{dpath}/itemdef.csv"],
      [@comment.uri+"#3",OPM.cause,"apicsvs:#{dpath}/data.csv"],
      [@comment.uri+"#4",OPM.effect,"amee:#{dpath}"],
      [@comment.uri,OPM.wasControlledBy,"james.hetherington"],
      [@comment.uri+"#1",OPM.effect,@comment.uri],
      [@comment.uri+"#2",OPM.effect,@comment.uri],
      [@comment.uri+"#3",OPM.effect,@comment.uri],
      [@comment.uri+"#4",OPM.cause,@comment.uri]
    ].each do |ss|
      @triples.should include *Statemented::enum_substatement(*ss).to_a
    end
  end
end

