# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Connection do

  it "should connect to Jira OK" do
    @jira=Connection::Jira.connect
    puts @jira.getProjectByKey("EX").name.should eql 'Explorer'
  end
end

