require 'spec_helper'

describe Brawl::Arena do

  let(:arena){Brawl::Arena.new(width: 100, height: 100)}
  
  it "should set the height when initialized" do
    Brawl::Arena.new(height: 100).height.should == 100
  end

  it "should set the width when initialized" do
    Brawl::Arena.new(width: 100).width.should == 100
  end

  it "should place an object in a given position" do
    arena.add_object("Howdy" => {x: 50, y: 50}).should be_true
  end

  it "should not place objects where there is an object already" do
    arena.add_object("Howdy" => {x: 50, y: 50})
    arena.add_object("Hi" => {x: 50, y: 50}).should be_false
  end
  
  it "should return object information for a position" do
    arena.add_object("Howdy" => {x: 50, y: 50})
    arena.ping(x: 50, y: 50).should == "Howdy"
  end
  
  it "should not return any information for an empty position" do
    arena.ping(x: 50, y: 50).should == nil
  end
  
  
  
end