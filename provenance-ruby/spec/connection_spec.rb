# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Connection do

  it "should connect to Jira OK" do
    @jira=Connection::Jira.connect
    @jira.getProjectByKey("EX").name.should eql 'Explorer'
  end
  it "should connect to Sesame OK" do
    @sesame=Connection::Sesame.connect
    @sesame.title.should eql 'AMEE Provenance Repository'
  end
  it "should connect to SVN OK" do
    @svn=Connection::Subversion.connect
    info= @svn.info(File.join(Connection::Subversion::Config['svn_repo_working_copy'],
        SubversionTestCategory))
    info[:url].
      should eql "#{Connection::Subversion::Config['svn_repo_master']}#{SubversionTestCategory}"
  end
end

