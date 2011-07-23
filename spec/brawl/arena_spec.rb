require 'spec_helper'

describe Brawl::Arena do

  let(:arena){Brawl::Arena.new(size: {width: 100, length: 100})}
  let(:object1){Brawl::BasicArenaObject.new}
  let(:object2){Brawl::BasicArenaobject.new}

  context "when determining size" do

    it "should set the size when initialized" do
      Brawl::Arena.new(
        size: {width: 100, length: 100}
      ).size.should == {width: 100, length: 100}
    end

    it "should have convinence method for length" do
      arena = Brawl::Arena.new(size: {width: 44, length: 923})
      arena.length.should == 923
    end

    it "should have convinence method for width" do
      arena = Brawl::Arena.new(size: {width: 234, length: 63})
      arena.width.should == 234
    end

  end

  context "when adding objects" do

    it "should place an object" do
      arena.add_object(object1).should be_true
    end
  
    it "should not place objects where there is an object already" do
      object1 = Brawl::BasicArenaObject.new(location: {x: 10, y: 10})
      object2 = Brawl::BasicArenaObject.new(location: {x: 10, y: 10})
      arena.add_object(object1)
      arena.add_object(object2).should be_false
    end
  
    it "should not place objects that already exist" do
      arena.add_object(object1)
      arena.add_object(object1).should be_false
    end

  end

  context "when removing objects" do
  
    it "should remove an object using the object itself" do
      arena.add_object(object1)
      arena.remove_object(object1).should == object1
    end
  
    it "should not remove objects that don't exist" do
      arena.remove_object(object1).should be_nil
    end
  
  end

  context "when moving objects" do

    before(:each) do
      object1 = Brawl::BasicArenaObject.new(location: {x: 50, y: 50})
      arena.add_object(object1)
    end

    it "should move an object from one location to another" do
      arena.move_object(object1 => {x: 1, y: 1}).should be_true 
    end

    it "should not move an object if its already in the location" do
      arena.move_object(object1 => {x: 50, y: 50}).should_not be_true
    end
  
    it "should move an object to the correct location" do
      arena.move_object(object1 => {x: 1, y: 1})
      object1.location.should == {x: 1, y: 1}
    end
  
    it "should not move above the bounds" do
      # note the zero based locations
      arena.move_object(object1 => {x: 0, y: 100}).should be_false
    end
  
    it "should not move below the bounds" do
      arena.move_object(object1 => {x: -1, y: 50}).should be_false
    end
    
  end

  context "when getting objects" do

    it "should retrieve objects by a key and value" do
      object1 = Brawl::BasicArenaObject.new(location: {x: 50, y: 50})
      arena.add_object(object1)
      arena.get_object(id: object1.id).should_not be_nil
    end

    it "should retrieve public object properties not the object itself" do
      object1 = Brawl::BasicArenaObject.new(location: {x: 50, y: 50})
      arena.add_object(object1)
      arena.get_object(id: object1.id).should == object1.properties
    end

  end
  
  context "when pinging locations for objects" do

    it "should return object information for a location" do
      object1 = Brawl::BasicArenaObject.new(location: {x: 50, y: 50})
      arena.add_object(object1)
      arena.ping(x: 50, y: 50).should == object1.properties
    end

    it "should return nothing for an empty location" do
      arena.ping(x: 50, y: 50).should be_nil
    end

    it "should return a wall for the areas around the arena" do
      arena.ping(x:-1,y:0).should == 
        {class: "Brawl::Wall", location: {x:-1, y:0}}
    end

    it "should return nothing for areas outside the wall" do
      # note that corners can't be "seen" from inside the arena so are not walls
      arena.ping(x:-1,y:-1).should    be_nil
      arena.ping(x:100,y:100).should  be_nil
      arena.ping(x:-1,y:100).should   be_nil
      arena.ping(x:100,y:-1).should   be_nil
      arena.ping(x:0,y:101).should    be_nil
      arena.ping(x:101,y:0).should    be_nil
      arena.ping(x:101,y:101).should  be_nil
    end

  end

end