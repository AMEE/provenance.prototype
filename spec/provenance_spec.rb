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
end

