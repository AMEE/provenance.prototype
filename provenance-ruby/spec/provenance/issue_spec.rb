
require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

describe Issue do
  it "should load comments with a mock jira" do
     @jira=flexmock
     @jira.should_receive(:base_url).and_return("http://example.com/jira")
     @jira.should_receive(:getIssue).with("EX-5").once
     @jira.should_receive(:getComments).with("EX-5").and_return(
       [
         flexmock(:id=>1),
         flexmock(:id=>2)
       ]
     ).once
     @jira.should_receive(:getComment).with(1).and_return(
       flexmock(:body=>'Mock body prov:test Hopeful')
     ).once
     @jira.should_receive(:getComment).with(2).and_return(
       flexmock(:body=>'Mock body prov:test Depressed')
     ).once
     @issue=Issue.new(@jira,'EX','5')
     @issue.comments[0].body.should match 'Mock body'
     @issue.comments.length.should eql 2
  end
  it "should load comments with a real jira" do
    @jira=Connection::Jira.connect
     @issue=Issue.new(@jira,'ST','50')
     @issue.comments[0].body.should match '/V4_10_Ch10_Livestock'
     @issue.should have_at_least(10).comments
  end
  
end

