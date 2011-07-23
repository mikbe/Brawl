require 'spec_helper'

# describe Brawl::ArenaProxy do
# 
#   let(:arena){Brawl::Arena.new(size: {width: 100, length: 100})}
#   let(:bot){Brawl::BasicBot.new(location: {x: 50, y: 50})}
#   let(:arena_proxy){Brawl::ArenaProxy.new(arena: arena, bot: bot)}
# 
#   it "should add the bot to the arena on initialization" do
#     arena_proxy = Brawl::ArenaProxy.new(arena: arena, bot: bot)
#     arena.get_object(id: bot.id).should_not be_nil
#   end
# 
#   it "should return arena length information" do
#     arena_proxy.length.should == arena.length
#   end
# 
#   it "should return arena width information" do
#     arena_proxy.width.should == arena.width
#   end
# 
#   # it "should move an object" do
#   #   arena_proxy.move(x: 11, y: 11).should be_true
#   # end
#   # 
#   # it "should ping a location" do
#   #   arena_proxy.ping(x:50, y: 50).should be_true
#   # end
# 
#   # How to do damage?
#   
#   # How do I allow for parts like weapons? What else am I missing?
#   
#   # A part should describe what properties it affects and how
#   
#   # should movement be a 'part?' Like should a motor be a part?
#   
#   # Properties for bots should be able to be added dynamically
#   
#   # When you hit something it should damage you. How much can be decided by
#   # the object and the receiver. (?)
#   
#   # There should be health as a basic property of a bot.
#   
# end