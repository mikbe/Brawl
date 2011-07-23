require 'spec_helper'

describe Brawl::BasicScanner do

  let(:arena){Brawl::Arena.new(size: {width: 100, length: 100})}
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

    it "should return an empty array of contacts if nothing is in range" # do
     #      bot = Brawl::BasicBot.new(
     #        arena: arena, 
     #        parts: {Brawl::BasicScanner=>{scan_max: 1, angle_max: 90}}
     #      )
     #      bot.scan(direction: 0, angle: 1).should be_empty
     #    end
#       
#     it "should find walls if in range" do
#       scanner = Brawl::BasicScanner.new(range: 6, max_angle: 180, bot: bot)
#       scanner.scan(direction: 0, angle: 1).should_not be_empty
#     end
#     
#     it "should find a wall type contact if in range" do
#       scanner.scan(direction: 0, angle: 1).any? 
#         {|contact| contact[:type] == :wall}.should be_true
#     end
#     
#     it "should find enemies if in range" do
#       enemy = double("Brawl::BasicBot")
#       enemy.stub!(:location).and_return({x: 3.0, y: 2.0})
#       arena.stub!(:bots).and_return([bot, enemy])
#       scanner = Brawl::BasicScanner.new(range: 3, max_angle: 180, bot: bot)
#       scanner.scan(direction: 0, angle: 1).any?
#         {|contact| contact[:type] == :enemy}.should be_true
#     end  
#     
#     it "should not find enemies if out of range" do
#       enemy = double("Brawl::BasicBot")
#       enemy.stub!(:location).and_return({x: 3.0, y: 2.0})
#       arena.stub!(:bots).and_return([bot, enemy])
#       scanner = Brawl::BasicScanner.new(range: 1, max_angle: 180, bot: bot)
#       scanner.scan(direction: 0, angle: 1).should be_empty
#     end  
#     
#     it "should find enemies to the side with a wide scan" do
#       arena.stub!(:width).and_return(100)
#       arena.stub!(:length).and_return(100)
#       bot.stub!(:arena).and_return(arena)
#       bot.stub!(:location).and_return({x: 20.0, y: 20.0})
#       bot.stub!(:heading).and_return(0)
#       arena.stub!(:bots).and_return([bot])
#       enemy = double("Brawl::BasicBot")
#       enemy.stub!(:location).and_return({x: 10.0, y: 20.0})
#       arena.stub!(:bots).and_return([bot, enemy])
#       scanner = Brawl::BasicScanner.new(range: 20, max_angle: 360, bot: bot)
#       scanner.scan(direction: 0, angle: 180).any?
#         {|contact| contact[:type] == :enemy}.should be_true
#     end  
#     
#     it "should find enemies on an oblique" do
#       arena.stub!(:width).and_return(100)
#       arena.stub!(:length).and_return(100)
#       bot.stub!(:arena).and_return(arena)
#       bot.stub!(:location).and_return({x: 20.0, y: 20.0})
#       bot.stub!(:heading).and_return(45)
#       arena.stub!(:bots).and_return([bot])
#       enemy = double("Brawl::BasicBot")
#       enemy.stub!(:location).and_return({x: 35.0, y: 35.0})
#       arena.stub!(:bots).and_return([bot, enemy])
#       scanner = Brawl::BasicScanner.new(range: 25, max_angle: 180, bot: bot)
#       scanner.scan(direction: 45, angle: 45).any?{|contact| contact[:type] == :enemy}.should be_true
#     end  
#
  end

end
