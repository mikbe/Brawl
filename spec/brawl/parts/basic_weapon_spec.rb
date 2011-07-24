require 'spec_helper'

describe Brawl::BasicWeapon do
    
  let(:arena){Brawl::Arena.new(size: {width: 10, length: 10})}
  let(:bot) do
    Brawl::BasicBot.new(
      arena: arena,
      location: {x: 5.0, y: 5.0},
      parts: {Brawl::BasicWeapon=>{range: 3, power: 1}}
    )
  end
  let(:enemy) do
    Brawl::BasicBot.new(
      arena: arena,
      location: {x: 6.0, y: 6.0},
      parts: {Brawl::BasicWeapon=>{range: 2, power: 1}}
    )
  end

  context "when firing" do

    it "should return enemy properties on a hit" do
      enemy = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 6.0, y: 6.0},
        parts: {Brawl::BasicWeapon=>{range: 2, power: 1}}
      )
      bot.shoot(45).should == enemy.properties.merge(distance:1.4, bearing:45.0)
    end

    it "should return wall properites on a hit" do
      bot = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 9.0, y: 5.0},
        parts: {Brawl::BasicWeapon=>{range: 2, power: 1}}
      )
      bot.shoot(90)[:class].should == Brawl::Wall
    end

    it "should nothing on a miss" do
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
      bot = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 5.0, y: 5.0},
        parts: {Brawl::BasicWeapon=>{range: 2, power: 1}}
      )
      enemy2 = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 5.0, y: 7.0},
        parts: {Brawl::BasicWeapon=>{range: 2, power: 1}}
      )
      
      bot.shoot(0).should == 
        enemy1.properties.merge(distance:1.0, bearing:0.0)
      
      
    end

    # it "should start the reload_countdown when firing" do
    #   expect{weapon.shoot at: 45}.should change(weapon, :reload_countdown).
    #     from(0.0)
    # end
    # 
    # it "should set the countdown based on the #reload_time" do
    #   weapon.shoot at: 45
    #   weapon.reload_countdown.should be_approximately(weapon.reload_time).within(0.02)
    # end
    # 
    # it "should adjust the countdown timer based on how long it's been since it was last shootd" do
    #   weapon.shoot at: 45
    #   sleep(0.2)
    #   weapon.reload_countdown.should be_approximately(weapon.reload_time).within(0.22)
    # end
    # 
    # it "should return true if it hits an enemy" do
    #   bot.stub!(:location).and_return({x: 5.0, y: 0.0})
    #   bot.stub!(:heading).and_return(0)
    #   enemy.stub!(:location).and_return({x: 5.0, y: 1.0})
    #   weapon.shoot(at: 0).should be_true
    # end
    # 
    # it "should return false if it doesn't hit an enemy" do
    #   bot.stub!(:location).and_return({x: 5.0, y: 0.0})
    #   bot.stub!(:heading).and_return(0)
    #   enemy.stub!(:location).and_return({x: 5.0, y: 1.0})
    #   weapon.shoot(at: 90).should be_false
    # end
    # 
  end
  
end