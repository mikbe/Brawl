require 'spec_helper'

describe Brawl::BasicScanner do
    
  let(:bot) {double("Brawl::BasicBot")}
  let(:arena) {double("Brawl::Arena")}
  let(:scanner) {Brawl::BasicScanner.new(range: 10, max_angle: 180, bot: bot)}
  
  it "should have a range property" do
    scanner.should respond_to(:range)
  end
  
  it "should have a max sweep property" do
    scanner.should respond_to(:max_angle)
  end

  it "should have a reference to its parent bot" do
    bot = double("Brawl::BasicBot")
    scanner = Brawl::BasicScanner.new bot: bot
    scanner.bot.should == bot
   end

  it "should initialize properties using a hash" do
    Brawl::BasicScanner.new(range: 10).range.should == 10
  end
  
  context "when scanning" do

    before(:each) do
      arena.stub!(:width).and_return(3)
      arena.stub!(:height).and_return(5)
      bot.stub!(:arena).and_return(arena)
      bot.stub!(:position).and_return({x: 3.0, y: 0.0})
      bot.stub!(:heading).and_return(0)
      arena.stub!(:bots).and_return([bot])
    end
  
    it "should return an empty array of contacts if nothing is in range" do
      scanner = Brawl::BasicScanner.new(range: 1, max_angle: 180, bot: bot)
      scanner.scan(direction: 0, angle: 1).should be_empty
    end
      
    it "should find walls if in range" do
      scanner = Brawl::BasicScanner.new(range: 6, max_angle: 180, bot: bot)
      scanner.scan(direction: 0, angle: 1).should_not be_empty
    end
    
    it "should find a wall type contact if in range" do
      scanner.scan(direction: 0, angle: 1).any?{|contact| contact[:type] == :wall}.should be_true
    end
    
    it "should find enemies if in range" do
      enemy = double("Brawl::BasicBot")
      enemy.stub!(:position).and_return({x: 3.0, y: 2.0})
      arena.stub!(:bots).and_return([bot, enemy])
      scanner = Brawl::BasicScanner.new(range: 3, max_angle: 180, bot: bot)
      scanner.scan(direction: 0, angle: 1).any?{|contact| contact[:type] == :enemy}.should be_true
    end  
    
    it "should not find enemies if out of range" do
      enemy = double("Brawl::BasicBot")
      enemy.stub!(:position).and_return({x: 3.0, y: 2.0})
      arena.stub!(:bots).and_return([bot, enemy])
      scanner = Brawl::BasicScanner.new(range: 1, max_angle: 180, bot: bot)
      scanner.scan(direction: 0, angle: 1).should be_empty
    end  
    
    it "should find enemies to the side with a wide scan" do
      arena.stub!(:width).and_return(100)
      arena.stub!(:height).and_return(100)
      bot.stub!(:arena).and_return(arena)
      bot.stub!(:position).and_return({x: 20.0, y: 20.0})
      bot.stub!(:heading).and_return(0)
      arena.stub!(:bots).and_return([bot])
      enemy = double("Brawl::BasicBot")
      enemy.stub!(:position).and_return({x: 10.0, y: 20.0})
      arena.stub!(:bots).and_return([bot, enemy])
      scanner = Brawl::BasicScanner.new(range: 20, max_angle: 360, bot: bot)
      scanner.scan(direction: 0, angle: 180).any?{|contact| contact[:type] == :enemy}.should be_true
    end  
    
    it "should find enemies on an oblique" do
      arena.stub!(:width).and_return(100)
      arena.stub!(:height).and_return(100)
      bot.stub!(:arena).and_return(arena)
      bot.stub!(:position).and_return({x: 20.0, y: 20.0})
      bot.stub!(:heading).and_return(45)
      arena.stub!(:bots).and_return([bot])
      enemy = double("Brawl::BasicBot")
      enemy.stub!(:position).and_return({x: 35.0, y: 35.0})
      arena.stub!(:bots).and_return([bot, enemy])
      scanner = Brawl::BasicScanner.new(range: 25, max_angle: 180, bot: bot)
      scanner.scan(direction: 45, angle: 45).any?{|contact| contact[:type] == :enemy}.should be_true
    end  

  end

end
