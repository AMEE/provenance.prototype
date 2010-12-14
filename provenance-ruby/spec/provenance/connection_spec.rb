require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

describe Connection do

  it "should connect to Jira OK" do
    @jira=Connection::Jira.connect
    @jira.getProjectByKey("EX").name.should eql 'Explorer'
  end
  it "should connect to Sesame OK" do
    @sesame=Connection::Sesame.connect
    @sesame.title.should match /AMEE Provenance/
  end
  it "should connect to SVN OK" do
    @svn=Connection::Subversion.connect
    info= @svn.info(File.join(Connection::Subversion::Config['svn_repo_working_copy'],'api_csvs',
        SubversionTestCategory))
    info[:url].
      should eql "#{Connection::Subversion::Config['svn_repo_master']}/api_csvs#{SubversionTestCategory}"
  end
end

