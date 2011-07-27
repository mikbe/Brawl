require 'spec_helper'

describe Brawl::BasicScanner do

  let(:arena){Brawl::Arena.new(size: {width: 10, length: 10})}
  let(:bot) do 
    Brawl::BasicBot.new(
      arena: arena, 
      parts: {Brawl::BasicScanner=>{scan_max: 10, angle_max: 90}}
    )
  end

  it "should set its maximum scan distance initialized" do
    bot.scan_max.should == 10
  end 

  it "should set its maximum scan angle initialized" do
    bot.angle_max.should == 90
  end 

  context "when scanning" do

    it "should return an empty array of contacts if nothing is in range" do
      bot = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 5, y: 5},
        parts: {Brawl::BasicScanner=>{scan_max: 1, angle_max: 90}}
      )
      bot.scan(direction: 0, angle: 1).should be_empty
    end

    it "should find walls if in range" do
      bot = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 5, y: 5},
        parts: {Brawl::BasicScanner=>{scan_max: 5, angle_max: 180}}
      )
      bot.scan(direction: 0, angle: 1).should_not be_empty
    end

    it "should find enemies if in range" do
      bot = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 5, y: 5},
        parts: {Brawl::BasicScanner=>{scan_max: 1, angle_max: 180}}
      )
      enemy = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 5, y: 6},
        parts: {Brawl::BasicScanner=>{scan_max: 1, angle_max: 180}}
      )
      scan = bot.scan(direction: 0, angle: 1)
      scan.any?{|contact| contact[:id] = enemy.id}
    end 

    it "should not find enemies if out of range" do
      bot = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 5, y: 5},
        parts: {Brawl::BasicScanner=>{scan_max: 1, angle_max: 180}}
      )
      enemy = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 5, y: 7},
        parts: {Brawl::BasicScanner=>{scan_max: 1, angle_max: 180}}
      )
      bot.scan(direction: 0, angle: 1).should be_empty
    end  
    
    it "should find enemies to the side with a wide scan" do
      bot = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 5, y: 5},
        parts: {Brawl::BasicScanner=>{scan_max: 3, angle_max: 180}}
      )
      enemy = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 5, y: 7},
        parts: {Brawl::BasicScanner=>{scan_max: 10, angle_max: 180}}
      )
      scan = bot.scan(direction: 0, angle: 180)
      scan.any?{|contact| contact[:id] = enemy.id}
    end

    it "should find enemies to the side with a wide scan" do
      bot = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 0, y: 0},
        parts: {Brawl::BasicScanner=>{scan_max: 10, angle_max: 180}}
      )
      enemy = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 7, y: 7},
        parts: {Brawl::BasicScanner=>{scan_max: 10, angle_max: 180}}
      )
      scan = bot.scan(direction: 0, angle: 180)
      scan.any?{|contact| contact[:id] = enemy.id}
    end  
  end

end
