require 'spec_helper'

describe Brawl::BasicWeapon do

  let(:clock){clock = Brawl::Clock.new(0.1)}
  let(:arena){Brawl::Arena.new(size: {width: 10, length: 10}, clock: clock)}
  let(:bot) do
    Brawl::BasicBot.new(
      arena: arena,
      location: {x: 5.0, y: 5.0},
      parts: {Brawl::BasicWeapon=>{range: 3, power: 1}}
    )
  end

  context "when firing" do
    
    it "should return enemy properties on a hit" do
      bot = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 1, y: 0},
        parts: {Brawl::BasicWeapon=>{range: 20, power: 1}}
      )
      enemy = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 8, y: 1},
        parts: {Brawl::BasicWeapon=>{range: 20, power: 1}}
      )
      bot.shoot(82).should_not be_nil
    end
    
    it "should return enemy properties on a hit" do
      bot = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 6, y: 1},
        parts: {Brawl::BasicWeapon=>{range: 20, power: 1}}
      )
      enemy = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 1, y: 4},
        parts: {Brawl::BasicWeapon=>{range: 20, power: 1}}
      )
      bot.shoot(301).should_not be_nil
    end
    
    it "should return enemy properties on a hit" do
      enemy = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 6, y: 6},
        parts: {Brawl::BasicWeapon=>{range: 50, power: 1}}
      )
      bot.shoot(45).should == 
      enemy.properties.merge(distance:1.4, bearing:45.0, health: 1)
    end

    it "should return wall properites on a hit" do
      bot = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 9.0, y: 5.0},
        parts: {Brawl::BasicWeapon=>{range: 3, power: 1}}
      )
      bot.shoot(90)[:class].should == Brawl::Wall
    end

    it "should return nothing on a miss" do
      bot = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 5.0, y: 5.0},
        parts: {Brawl::BasicWeapon=>{range: 2, power: 1}}
      )
      bot.shoot(90).should be_nil
    end

    it "should hit the closest object" do
      enemy1 = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 5.0, y: 6.0},
        parts: {Brawl::BasicWeapon=>{range: 2, power: 1}}
      )
      enemy2 = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 5.0, y: 7.0},
        parts: {Brawl::BasicWeapon=>{range: 2, power: 1}}
      )
      bot = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 5.0, y: 5.0},
        parts: {Brawl::BasicWeapon=>{range: 2, power: 1}}
      )
      bot.shoot(0).should == enemy1.properties.merge(
        distance:1.0, bearing:0.0, health: 1
      )
      
    end

    it "should damage an enemy" do
      enemy = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 5.0, y: 6.0},
        parts: {Brawl::BasicWeapon=>{range: 2, power: 1}}
      )
      expect{bot.shoot}.should change(enemy, :health).by(-1)
    end
    
  end

  context "when reloading" do

    it "should start the reload_countdown when firing" do
      expect{bot.shoot}.should change(bot, :reload_countdown).from(0)
    end
    
    it "should set the countdown based on the #reload_time" do
      bot = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 9.0, y: 5.0},
        parts: {Brawl::BasicWeapon=>{range: 2, power: 1, reload_time: 10}}
      )
      expect{bot.shoot}.should change(bot, :reload_countdown).to(10)
    end
    
    it "should count down based on clock ticks since last shot" do
      bot = Brawl::BasicBot.new(
        arena: arena,
        parts: {Brawl::BasicWeapon=>{range: 2, power: 1, reload_time: 10}}
      )
      clock.start
      bot.shoot
      sleep(0.3)
      clock.stop
      bot.reload_countdown.should be_within(5.1).of(bot.reload_time)
    end

    it "should not fire when the reload countdown is still going" do
      bot.shoot 90
      enemy = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 6.0, y: 6.0},
        parts: {Brawl::BasicWeapon=>{range: 2, power: 1}}
      )
      bot.shoot(45).should == false
      
    end

  end

end