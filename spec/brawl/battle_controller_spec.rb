require 'spec_helper'

describe Brawl::BattleController do

  # How would I use it?
=begin

  bc = BattleController.new(arena: arena, bots: [bot1, bot2])
  view = SomeView.new(bc)

  bc = BattleController.new(arena: arena, bots: [bot1, bot2])
  

=end

  #let(:arena){Brawl::Arena.new(size: {width: 100, length: 100})}

  # testing internal state!
  it "should set the arena when initialized" do
    arena   = Brawl::Arena.new(size: {width: 100, length: 100})
    battle  = Brawl::BattleController.new(
      arena: arena, 
      bots: {Brawl::BasicBot => 2}
    )
    
    
    # battle.arena.should == arena
  end


end