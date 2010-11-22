require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

Subject="Hello world I really like to do string manipulation"

describe "text narrower" do
  include Utils
  it "Should not effect short string" do
    narrow(Subject,80).should eql Subject
  end
  it "Should do right by a medium string" do
    narrow(Subject,20).should eql "Hello world I\nreally like to do\nstring manipulation"
  end
  it "Should do right by a long string" do
    narrow(Subject,8).should eql "Hello\nworld I\nreally\nlike to\ndo\nstring\nmanipulation"
  end
end
