require 'spec_helper'

describe Brawl::Bot do
    
  let(:arena) {double("Brawl::Arena")}
  let(:bot) {Brawl::Bot.new position: {x: 0.0, y: 0.0}, heading: 0}
  
  it "should know its position" do
    expect{bot.position}.should_not raise_exception
  end
  
  it "should initizlize properties using a hash" do
    Brawl::Bot.new(position: {x: 10.0, y: 10.0}, heading: 50).position.should == {x: 10.0, y: 10.0}
  end
  
  context "When moving" do

    it "should move forward one space" do
      expect{bot.move}.should change(bot, :position).
       from({x: 0.0, y: 0.0}).
       to({x: 0.0, y: 1.0})
    end

    it "should move forward one space" do
      bot.turn :right
      expect{bot.move}.should change(bot, :position).
       from({x: 0.0, y: 0.0}).
       to({x: 1.0, y: 0.0})
    end

    it "should move in the direction it is facing" do
      bot.turn to_angle: 45
      expect{bot.move}.should change(bot, :position).
       from({x: 0.0, y: 0.0}).
       to({x: 0.7, y: 0.7})
    end
    
  end
  
  context "when turning" do
     
    context "and giving an angle" do
      
      it "should turn to the angle specified" do
        expect{bot.turn to_angle: 45}.should change(bot, :heading).
          from(0).
          to(45)
      end
    
      it "should turn in the direction specified" do
        bot.turn to_angle: 45
        expect{bot.turn by_degrees: 45}.should change(bot, :heading).
          from(45).
          to(90)
      end
    
      it "should convert heading 360 to 0" do
        bot.turn to_angle: 359
        expect{bot.turn by_degrees: 1}.should change(bot, :heading).
          from(359).
          to(0)
      end

      it "should 'wrap-around' degrees" do
        bot.turn to_angle: 300
        expect{bot.turn by_degrees: 90}.should change(bot, :heading).
          from(300).
          to(30)
      end
    end

    context "and giving a degree" do
      
      it "should 'wrap-around' degrees given" do
        expect{bot.turn by_degrees: 390}.should change(bot, :heading).
          from(0).
          to(30)
      end

      it "should turn by negative degrees" do
        expect{bot.turn by_degrees: -90}.should change(bot, :heading).
          from(0).
          to(270)
      end
      
    end

    context "and given a direction name" do
      
      it "should turn left" do
        expect{bot.turn :left}.should change(bot, :heading).
          from(0).
          to(270)
      end

      it "should turn right" do
        expect{bot.turn :right}.should change(bot, :heading).
          from(0).
          to(90)
      end

      it "should turn around" do
        expect{bot.turn :around}.should change(bot, :heading).
          from(0).
          to(180)
      end

      
    end
    
  end
  
end