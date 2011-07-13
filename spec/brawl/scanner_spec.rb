require 'spec_helper'

describe Brawl::Scanner do
    
  let(:bot) {double("Brawl::Bot")}
  let(:arena) {double("Brawl::Arena")}
  let(:scanner) {Brawl::Scanner.new(range: 10, max_sweep: 180, bot: bot)}
  
  it "should have a range property" do
    expect{scanner.range}.should_not raise_error
  end
  
  it "should have a max sweep property" do
    expect{scanner.max_sweep}.should_not raise_error
  end

  it "should have a reference to its parent bot" do
    bot = double("Brawl::Bot")
    scanner = Brawl::Scanner.new bot: bot
    scanner.bot.should == bot
   end

  it "should initialize properties using a hash" do
    Brawl::Scanner.new(range: 10).range.should == 10
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
      scanner = Brawl::Scanner.new(range: 5, max_sweep: 180, bot: bot)
      scanner.scan(angle: 0, sweep: 1).should be_empty
    end
  
    it "should find walls if in range" do
      scanner = Brawl::Scanner.new(range: 6, max_sweep: 180, bot: bot)
      scanner.scan(angle: 0, sweep: 1).should_not be_empty
    end

    it "should find a wall type contact if in range" do
      scanner.scan(angle: 0, sweep: 1).any?{|contact| contact[:type] == :wall}.should be_true
    end

    it "should find enemies if in range" do
      enemy = double("Brawl::Bot")
      enemy.stub!(:position).and_return({x: 3.0, y: 2.0})
      arena.stub!(:bots).and_return([bot, enemy])
      scanner = Brawl::Scanner.new(range: 2, max_sweep: 180, bot: bot)
      scanner.scan(angle: 0, sweep: 1).should_not be_empty
    end  

    it "should not find enemies if out of range" do
      enemy = double("Brawl::Bot")
      enemy.stub!(:position).and_return({x: 3.0, y: 2.0})
      arena.stub!(:bots).and_return([bot, enemy])
      scanner = Brawl::Scanner.new(range: 1, max_sweep: 180, bot: bot)
      scanner.scan(angle: 0, sweep: 1).should be_empty
    end  

  end

end
