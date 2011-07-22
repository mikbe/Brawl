# require 'spec_helper'
# 
# describe Brawl::BasicWeapon do
#     
#   let(:bot) {Brawl::BasicBot}
#   let(:enemy) {Brawl::BasicBot}
#   let(:arena) {Brawl::Arena.new}
#   let(:weapon) {Brawl::BasicWeapon.new(range: 2, power: 1, bot: bot)}
# 
#   before(:each) do
#     arena = Brawl::Arena.new(height: 10, width: 10)
#     bot   = Brawl::BasicBot.new(arena: arena, position: {x: 5.0, y: 0.0})
#     enemy = Brawl::BasicBot.new(arena: arena, position: {x: 5.0, y: 1.0})
#     #arena.add_bots([bot,enemy])
#   end
#   
#   it "should have a range property" do
#     weapon.should respond_to(:range)
#   end
#   
#   it "should have a reload timer" do
#     weapon.should respond_to(:reload_countdown)
#   end
#   
#   it "should have a reload timer" do
#     weapon.should respond_to(:reload_time)
#   end
#   
#   it "should have a power rating" do
#     weapon.should respond_to(:power)
#   end
# 
#   it "should initialize properties using a hash" do
#     Brawl::BasicWeapon.new(power: 5).power.should == 5
#   end
#   
#   context "when firing" do
# 
#     it "should fire at a specific angle" do
#       weapon.fire(at: 45).should_not be_nil
#     end
# 
#     it "should fire at a relative angle" do
#       weapon.fire(relative: 45).should_not be_nil
#     end
#     
#     it "should start the reload_countdown when firing" do
#       expect{weapon.fire at: 45}.should change(weapon, :reload_countdown).
#         from(0.0)
#     end
# 
#     it "should set the countdown based on the #reload_time" do
#       weapon.fire at: 45
#       weapon.reload_countdown.should be_approximately(weapon.reload_time).within(0.02)
#     end
#     
#     it "should adjust the countdown timer based on how long it's been since it was last fired" do
#       weapon.fire at: 45
#       sleep(0.2)
#       weapon.reload_countdown.should be_approximately(weapon.reload_time).within(0.22)
#     end
#     
#     it "should return true if it hits an enemy" do
#       bot.stub!(:position).and_return({x: 5.0, y: 0.0})
#       bot.stub!(:heading).and_return(0)
#       enemy.stub!(:position).and_return({x: 5.0, y: 1.0})
#       weapon.fire(at: 0).should be_true
#     end
#     
#     it "should return false if it doesn't hit an enemy" do
#       bot.stub!(:position).and_return({x: 5.0, y: 0.0})
#       bot.stub!(:heading).and_return(0)
#       enemy.stub!(:position).and_return({x: 5.0, y: 1.0})
#       weapon.fire(at: 90).should be_false
#     end
#     
#   end
#   
# end