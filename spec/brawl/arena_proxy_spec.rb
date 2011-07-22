require 'spec_helper'

describe Brawl::ArenaProxy do

  let(:arena){Brawl::Arena.new(width: 100, height: 100)}
  let(:arena_proxy){Brawl::ArenaProxy.new(arena)}
  
  it "should forward height" do
    arena_proxy.height.should == arena.height
  end
  
  it "should forward width" do
    arena_proxy.width.should == arena.width
  end

  it "should move an object" do
    object = "Howdy"
    arena.add_object(object => {x: 10, y: 10})

    arena_proxy.move(object => {x: 11, y: 10}).should be_true
  end

end