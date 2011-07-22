# require 'spec_helper'
# 
# describe Brawl::BasicBot do
#     
#   let(:arena) {Brawl::Arena.new}
#   let(:bot) {
#     Brawl::BasicBot.new(
#       position: {x: 0.0, y: 0.0}, 
#       heading: 0, 
#       arena: arena
#     )
#   }
#   
#   context "when initializing" do
# 
#     it "should read its position from the arena" do
#       bot = Brawl::BasicBot.new(arena: arena)
#       arena.place_object(bot => {x: 10.0, y: 20.0})
#       bot.position.should == {x: 10.0, y: 20.0}
#     end
# 
#     it "should set its position when initialize" do
#       Brawl::BasicBot.new(
#         position: {x: 10.0, y: 20.0},
#         arena: arena 
#       ).position.should == {x: 10.0, y: 20.0}
#     end
# 
#     it "should set its heading when initialize" do
#       Brawl::BasicBot.new(
#         heading: 145
#       ).heading.should == 145
#     end
# 
#     it "should set the arena its in when initialize" do
#       Brawl::BasicBot.new(
#         arena: arena
#       ).arena.should == arena
#     end
# 
#     # this is how I intend to add features like different weapons and whatnot
#     it "should have the methods of the parts that are injected into it" do
#       # I think this is a proper use of doubles and stubs 
#       scanner = double("Brawl::BasicScanner")
#       scanner.stub!("scantastic!")
#       bot = Brawl::BasicBot.new(
#         position: {x: 0.0, y: 0.0}, 
#         heading: 0, 
#         arena: arena, 
#         parts:{scanner: scanner}
#       )
#       bot.should respond_to(:scantastic!)
#     end
#   
#   end
#   
#   context "when moving" do
#   
#     it "should know its position" do
#       expect{bot.position}.should_not raise_exception
#     end
# 
#     it "should move forward one space" do
#       expect{bot.move}.should change(bot, :position).
#        from({x: 0.0, y: 0.0}).
#        to({x: 0.0, y: 1.0})
#     end
# 
#     it "should move forward one space" do
#       bot.turn :right
#       expect{bot.move}.should change(bot, :position).
#        from({x: 0.0, y: 0.0}).
#        to({x: 1.0, y: 0.0})
#     end
# 
#     it "should move in the direction it is facing" do
#       bot.turn to_angle: 45
#       expect{bot.move}.should change(bot, :position).
#        from({x: 0.0, y: 0.0}).
#        to({x: 0.7, y: 0.7})
#     end
#     
#   end
#   
#   context "when turning" do
#      
#     context "and given an angle" do
#       
#       it "should turn to the angle specified" do
#         expect{bot.turn to_angle: 45}.should change(bot, :heading).
#           from(0).
#           to(45)
#       end
#     
#       it "should turn in the direction specified" do
#         bot.turn to_angle: 45
#         expect{bot.turn by_degrees: 45}.should change(bot, :heading).
#           from(45).
#           to(90)
#       end
#     
#       it "should convert heading 360 to 0" do
#         bot.turn to_angle: 359
#         expect{bot.turn by_degrees: 1}.should change(bot, :heading).
#           from(359).
#           to(0)
#       end
# 
#       it "should 'wrap-around' degrees" do
#         bot.turn to_angle: 300
#         expect{bot.turn by_degrees: 90}.should change(bot, :heading).
#           from(300).
#           to(30)
#       end
#     end
# 
#     context "and given a degree" do
#       
#       it "should 'wrap-around' degrees given" do
#         expect{bot.turn by_degrees: 390}.should change(bot, :heading).
#           from(0).
#           to(30)
#       end
# 
#       it "should turn by negative degrees" do
#         expect{bot.turn by_degrees: -90}.should change(bot, :heading).
#           from(0).
#           to(270)
#       end
#       
#     end
# 
#     context "and given a direction name" do
#       
#       it "should turn left" do
#         expect{bot.turn :left}.should change(bot, :heading).
#           from(0).
#           to(270)
#       end
# 
#       it "should turn right" do
#         expect{bot.turn :right}.should change(bot, :heading).
#           from(0).
#           to(90)
#       end
# 
#       it "should turn around" do
#         expect{bot.turn :around}.should change(bot, :heading).
#           from(0).
#           to(180)
#       end
#       
#     end
#     
#   end
#   
# end