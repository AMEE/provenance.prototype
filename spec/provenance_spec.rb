# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Provenance do
  it "should exec the executable" do
    begin
      oldpath=ENV['PATH']
      ENV['PATH']+=":#{File.expand_path(File.dirname(File.dirname(__FILE__)))}/bin"
      res=system("provenance EX-50 ")
      res.should be_true
    ensure
      ENV['PATH']=oldpath
    end
  end
  it "should parse issue" do
    Provenance.new("EX-590").issue.should eql 590
    Provenance.new("EX-590").project.should eql 'EX'
    Provenance.new("EX").project.should eql 'EX'
    Provenance.new("EX").issue.should be_nil
  end
end

