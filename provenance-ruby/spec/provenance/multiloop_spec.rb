require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

describe Multiloop do
  include Multiloop
  it "Should loop" do
    combos=[]
    all(1,[2,3,4],[5,6],[7,8]) do |combo|
      combos<<combo
    end
    combos.should eql [
      [1, 2, 5, 7],
      [1, 2, 5, 8],
      [1, 2, 6, 7],
      [1, 2, 6, 8],
      [1, 3, 5, 7],
      [1, 3, 5, 8],
      [1, 3, 6, 7],
      [1, 3, 6, 8],
      [1, 4, 5, 7],
      [1, 4, 5, 8],
      [1, 4, 6, 7],
      [1, 4, 6, 8]
    ]
  end
end
