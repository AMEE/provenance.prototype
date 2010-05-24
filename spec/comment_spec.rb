# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Comment do
  
  it "should create comments from a mock jira" do
    @jira=flexmock
  end
  it "should create comments from a real jira" do
    @jira=Connection::Jira.connect
    @comment=Comment.new(@jira,'EX-1')
    @comment.commands[0].should be_a Commands::Test
  end
end

