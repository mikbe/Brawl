require 'spec_helper'
$DEBUG=true
Thread.abort_on_exception

describe Brawl::BattleController do

  let(:arena_data) {{size: {width: 10, length: 10}}}
  let(:clock_data) {{tick_rate: 0.01}}

  let(:motor)   { {Brawl::BasicMotor=>{move_max: 1, turn_max: 360}} }
  let(:scanner) { {Brawl::BasicScanner=>{scan_max: 30, angle_max: 360}} }
  let(:weapon)  { {Brawl::BasicWeapon=>{range: 20, power: 1}} }
  let(:parts)   {  motor.merge(scanner).merge(weapon) }

  let(:bot_code) do
    <<-CODE
    code do |bot|
      puts
      puts "Basic bot... meh."
      if rand(0) > 0.5
        bot.turn [:left,:right,:around].sample
      end
      bot.move rand(3) + 1
    end
    CODE
  end
  let(:bot1) do
    {
      name: "Basic Bot 1",
      class: Brawl::BasicBot,
      params: {parts: parts},
      code: bot_code
    }
  end


  let(:helpless_bot_code) do
    <<-CODE
    code do |bot|
      sleep(0.05)
    end
    CODE
  end
  let(:helpless_bot1) do
    {
      name: "Helpless Bot 1",
      class: Brawl::BasicBot,
      params: {parts: parts},
      code: helpless_bot_code
    }
  end

  let(:battle_bot_code) do
    <<-CODE
    code do |bot|
      @dir ||= 0
      # puts
      # puts "Battle Bot!"
      # puts "scan: \#{@dir}"
      targets = bot.scan direction: @dir, angle: 90
      @dir += 45
      @dir %= 360
      targets.each do |target|
        unless target[:class] == Brawl::Wall
          # puts "  target: \#{target[:name]}"
          # puts " bearing: \#{target[:bearing]}"
          # puts "distance: \#{target[:distance]}"
          results = shoot(target[:bearing])
          # puts "shoot results: \#{results}"
        end
      end
    end
    CODE
  end
  let(:battle_bot1) do
    {
      name: "Battle Bot 1",
      class: Brawl::BasicBot,
      params: {parts: parts},
      code: battle_bot_code
    }
  end

  context "when configuring the controller" do

    it "should create an arena object" do
      battle = Brawl::BattleController.new
      battle.make_arena(arena_data)
      battle.arena.should be_a(Brawl::Arena)
    end

    it "should create a clock object" do
      battle = Brawl::BattleController.new
      battle.make_clock(clock_data)
      battle.clock.should be_a(Brawl::Clock)
    end

    it "should set the arena's clock to the created clock" do
      battle = Brawl::BattleController.new
      battle.make_arena(arena_data)
      battle.make_clock(clock_data)
      battle.arena.clock.should == battle.clock
    end

    it "should create bots" do
      battle = Brawl::BattleController.new
      battle.make_arena(arena_data)
      battle.make_clock(clock_data)

      bot_data = [bot1]
      battle.make_bots(bot_data)

      battle.bots.should_not be_empty
    end

  end

  context "when running bots" do

    it "should stop when one bot reaches 0 health" do
      battle = Brawl::BattleController.new
      battle.make_arena(arena_data)
      battle.make_clock(clock_data)

      bot_data = [helpless_bot1, battle_bot1]
      battle.make_bots(bot_data)
      puts "victory? #{battle.victory?}"
      battle.start
      until battle.victory?
        sleep(0.5)
      end
      puts "victory? #{battle.victory?}"
    end

  end

end
