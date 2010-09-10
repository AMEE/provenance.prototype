require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TextFile do
  it "should load steps with a real file" do
    @file=File.new "#{Resources}/something.prov"
    @issue=TextFile.new(@file)
    @issue.steps[0].body.should match 'Mock body'
    @issue.steps.length.should eql 2
  end
end
