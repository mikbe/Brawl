require 'spec_helper'

describe Brawl::Arena do

  let(:arena){Brawl::Arena.new(width: 100, height: 100)}
  
  it "should set the height when initialized" do
    Brawl::Arena.new(height: 100).height.should == 100
  end

  it "should set the width when initialized" do
    Brawl::Arena.new(width: 100).width.should == 100
  end

  it "should add a bot to the list of bots in the arena" do
    bot = Brawl::BasicBot.new
    expect{arena.add_bot(bot)}.should 
      change(arena.bots, :count).
      by(1)
  end
  
end