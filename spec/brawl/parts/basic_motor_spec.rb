require 'spec_helper'

describe Brawl::BasicMotor do

  let(:arena){Brawl::Arena.new(size: {width: 100, length: 100})}
  let(:bot) do 
    Brawl::BasicBot.new(
      arena: arena, 
      parts: {Brawl::BasicMotor=>{move_max: 3, turn_max: 360}}
    )
  end

  context "when moving" do

    it "should move forward one space" do
      expect{bot.move 1}.should change(bot, :location).
       from({x: 0.0, y: 0.0}).
       to({x: 0.0, y: 1.0})
    end
    
    it "should move forward one space" do
      bot.turn :right
      
      expect{bot.move}.should change(bot, :location).
       from({x: 0.0, y: 0.0}).
       to({x: 1.0, y: 0.0})
    end
    
    it "should move in the direction it is facing" do
      bot.turn to_angle: 45
      expect{bot.move}.should change(bot, :location).
       from({x: 0.0, y: 0.0}).
       to({x: 0.7, y: 0.7})
    end

    it "should not move more than the maximum allowed" do
      expect{bot.move 5}.should change(bot, :location).
       from({x: 0.0, y: 0.0}).
       to({x: 0.0, y: 3.0})
    end

    it "should not move into walls" do
      bot = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 0, y:99},
        parts: {Brawl::BasicMotor=>{move_max: 3, turn_max: 360}}
      )
      expect{bot.move}.should_not change(bot, :location)
    end

    it "should move in reverse" do
      bot = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 50, y:50},
        parts: {Brawl::BasicMotor=>{move_max: 3, turn_max: 360}}
      )
      expect{bot.move -1}.should change(bot, :location).
       from({x: 50.0, y: 50.0}).
       to({x: 50.0, y: 49.0})
    end

    it "should not move in reverse more than the maximum allowed" do
      bot = Brawl::BasicBot.new(
        arena: arena,
        location: {x: 50, y:50},
        parts: {Brawl::BasicMotor=>{move_max: 3, turn_max: 360}}
      )
      expect{bot.move -5}.should change(bot, :location).
       from({x: 50.0, y: 50.0}).
       to({x: 50.0, y: 47.0})
    end


  end
    
  context "when turning" do

    context "and given an angle" do

      it "should 'wrap-around' degrees given" do
        expect{bot.turn to_angle: 390}.should change(bot, :heading).
          from(0).
          to(30)
      end

      it "should turn by negative degrees" do
        expect{bot.turn to_angle: -90}.should change(bot, :heading).
          from(0).
          to(270)
      end

      it "should turn to a positive angle within its maximum turn rate" do
        bot = Brawl::BasicBot.new(
          arena: arena, 
          parts: {Brawl::BasicMotor=>{move_max: 3, turn_max: 90}}
        )
        bot.turn to_angle: 40
        expect{bot.turn to_angle: 320}.should change(bot, :heading).
          from(40).
          to(320)
      end

      it "should turn by negative degrees within its maximum turn rate" do
        bot = Brawl::BasicBot.new(
          arena: arena, 
          parts: {Brawl::BasicMotor=>{move_max: 3, turn_max: 90}}
        )
        bot.turn to_angle: 40
        expect{bot.turn to_angle: -40}.should change(bot, :heading).
          from(40).
          to(320)
      end

      it "should not turn more than its maximum turn rate" do
        bot = Brawl::BasicBot.new(
          arena: arena, 
          parts: {Brawl::BasicMotor=>{move_max: 3, turn_max: 90}}
        )
        expect{bot.turn to_angle: 91}.should change(bot, :heading).
          from(0).
          to(90)
      end

      it "should not turn more than its maximum turn rate counter-clockwise" do
        bot = Brawl::BasicBot.new(
          arena: arena, 
          parts: {Brawl::BasicMotor=>{move_max: 3, turn_max: 90}}
        )
        expect{bot.turn to_angle: -91}.should change(bot, :heading).
          from(0).
          to(270)
      end


    end

    context "and given degrees" do
      
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

      it "should 'wrap-around' degrees larger than 360" do
        expect{bot.turn by_degrees: 390}.should change(bot, :heading).
          from(0).
          to(30)
      end

     it "should turn using negative degrees" do
       bot = Brawl::BasicBot.new(
         arena: arena, 
         parts: {Brawl::BasicMotor=>{move_max: 3, turn_max: 90}}
       )
       
       bot.turn to_angle: 20
       expect{bot.turn by_degrees: -40}.should change(bot, :heading).
         from(20).
         to(340)
     end

      it "should not turn more than its maximum turn rate" do
        bot = Brawl::BasicBot.new(
          arena: arena, 
          parts: {Brawl::BasicMotor=>{move_max: 3, turn_max: 90}}
        )
        expect{bot.turn by_degrees: 91}.should change(bot, :heading).
          from(0).
          to(90)
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