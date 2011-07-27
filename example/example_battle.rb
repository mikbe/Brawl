$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "/../lib"))
$: << '.'

require 'brawl'

battle_bot_code = <<CODE
code do |bot|
  @dir ||= 0
  targets = bot.scan direction: @dir, angle: 90
  @dir += 45
  @dir %= 360
  unless targets.each do |target|
      unless target[:class] == Brawl::Wall
        results = shoot(target[:bearing])
      end
    end.empty?
  else
    if rand(0) > 0.5
      bot.turn [:left,:right,:around].sample
    end
    bot.move rand(3) + 1
  end
end
CODE

arena_data = {size: {width: 50, length: 50}}
clock_data = {tick_rate: 0.01}

motor   = {Brawl::BasicMotor=>{move_max: 3, turn_max: 360}}
scanner = {Brawl::BasicScanner=>{scan_max: 10, angle_max: 180}}
weapon  = {Brawl::BasicWeapon=>{range: 11, power: 1}}
parts   =  motor.merge(scanner).merge(weapon)

battle_bot1 =
{
  name: "Battle Bot 1",
  class: Brawl::BasicBot,
  params: {parts: parts},
  code: battle_bot_code
}

battle_bot2 =
{
  name: "Battle Bot 2",
  class: Brawl::BasicBot,
  params: {parts: parts},
  code: battle_bot_code
}

battle_bot3 =
{
  name: "Battle Bot 3",
  class: Brawl::BasicBot,
  params: {parts: parts},
  code: battle_bot_code
}

battle_bot4 =
{
  name: "Battle Bot 4",
  class: Brawl::BasicBot,
  params: {parts: parts},
  code: battle_bot_code
}

class LogView

  def initialize(logfile)
    @logfile = logfile
    @file = nil
  end

  def open
    @file = File.open(@logfile, "w")
  end

  def close
    @file.flush
    @file.close
  end

  def write(msg)
    @file.puts msg
  end

  def bot_msg_callback(*params)

    bot_info      = params[0]
    method        = params[1]
    method_params = params[2]

    case method
      when :damage
        @file.puts
        @file.puts "#{bot_info[:name]}" +
        " at #{bot_info[:location]}" +
        " was hit for #{method_params} damage" +
        " and now has #{bot_info[:health]} health"
        @file.puts "#{bot_info[:name]} is dead!" if bot_info[:health] == 0
      when :scan
        @file.puts
        @file.puts "#{bot_info[:name]}" +
        " at #{bot_info[:location]}" +
        " scans #{method_params}"
      when :move
        @file.puts
        @file.puts "#{bot_info[:name]}" +
        " at #{bot_info[:location]}" +
        " moves #{method_params}"
      when :shoot
        @file.puts
        @file.puts "#{bot_info[:name]}" +
        " at #{bot_info[:location]}" +
        " shoots at bearing #{method_params.round(1)}."
    end
  end

end

battle = Brawl::BattleController.new
battle.make_arena(arena_data)
battle.make_clock(clock_data)

bot_data = [battle_bot1, battle_bot2, battle_bot3, battle_bot4]
battle.make_bots(bot_data)
log = LogView.new("logview.txt")
log.open
battle.register_for_event(
  event:    :bot_msg,
  listener: log,
  callback: :bot_msg_callback
)

battle.start
until battle.victory?
  sleep(0.5)
end
log.write "Battle won!"
winner = battle.arena.get_object(class: Brawl::BasicBot)
log.write "#{winner[:name]} is the champion!"
log.close
