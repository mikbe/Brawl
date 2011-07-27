$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "/../../lib"))
$: << '.'
require 'brawl'
$DEBUG=true
Thread.abort_on_exception

arena_data = {size: {width: 10, length: 10}}
clock_data = {tick_rate: 0.25}

motor   = {Brawl::BasicMotor=>{move_max: 1, turn_max: 360}}
scanner = {Brawl::BasicScanner=>{scan_max: 10, angle_max: 180}}
weapon  = {Brawl::BasicWeapon=>{range: 3, power: 1}}
parts   = motor.merge(scanner).merge(weapon)

bot_code = <<-CODE
  code do |bot|
    if rand(0) > 0.5
      bot.turn [:left,:right,:around].sample
    end
    bot.move rand(3) + 1
  end
  CODE

bot1 =
  {
    name: "Basic Bot 1",
    class: Brawl::BasicBot,
    params: {parts: parts},
    code: bot_code
  }

battle_bot_code = <<-CODE
  code do |bot|
    puts "Battle Bot!"
    targets = bot.scan direction: 0, angle: 180
    # targets.each do |target|
    #   unless target.class == Brawl::Wall
    #     puts target
    #   end
    # end
  end
  CODE

battle_bot1 =
  {
    name: "Battle Bot 1",
    class: Brawl::BasicBot,
    params: {parts: parts},
    code: battle_bot_code
  }

battle = Brawl::BattleController.new
battle.make_arena(arena_data)
battle.make_clock(clock_data)

bot_data = [bot1, battle_bot1]
battle.make_bots(bot_data)

battle.start

sleep(3)

