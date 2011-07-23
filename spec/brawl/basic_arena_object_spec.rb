require 'spec_helper'

describe Brawl::BasicArenaObject do

  let(:object){Brawl::BasicArenaObject.new}

  it "should set a globally unique ID" do
    object.id.should_not be_nil
  end

  it "should set a default location of {x: 0, y: 0}" do
    object.location.should == {x: 0, y: 0}
  end

  it "should set a default heading of 0" do
    object.heading.should == 0
  end

  it "should set a default health of 1" do
    object.health.should == 1
  end

  it "should override a default value if a specific value is given" do
    object = Brawl::BasicArenaObject.new(health: 20)
    object.health.should == 20
  end

  it "should have a hash of property values" do
    object.properties.should be_a(Hash)
  end

end