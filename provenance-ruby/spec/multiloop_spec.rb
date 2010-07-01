require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Multiloop do
  include Multiloop
  it "Should loop" do
    combos=[]
    all(1,[2,3,4],[5,6],[7,8]) do |combo|
      combos<<combo
    end
    pp combos
  end
end
