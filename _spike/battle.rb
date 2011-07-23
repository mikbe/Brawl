$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "/../lib"))
require 'brawl'

module Brawl
  
  class Proxy
    
    attr_accessor :bot
    
    def initialize(bot, code)
      @bot, @code = bot, code
      add_proxy_methods
    end

    #this is where I can put timing in
    def add_proxy_methods
      puts "proxy: #{@bot.public_methods(false)}"
      @bot.public_methods(false).each do |method|
        singleton_class.send :define_method, method do |*params, &block|
          puts "calling: #{method}(#{params.join})"
          @bot.send method, *params, &block
        end
      end
    end

    def run_code
      puts "run_code"
      instance_eval @code
    end

    def code
      yield self
    end

  end
  
  class BattleController
    
    attr_accessor :arena, :bots
    
    def initialize(params)
      super
      arena = params[:arena]
      bots  = params[:bots]
      @arena = arena[:class].new(arena[:parameters])
      @bots = {}
      bots.each do |bot|
        puts "add: #{bot[:name]}, #{bot[:class]}"
        @bots[bot[:name]] = Proxy.new(
              bot[:class].new(bot[:parameters].merge(arena: @arena)),
              bot[:code]
        )
      end
    end
    
    def run
      10.times do |index|
        puts
        puts "turn: #{index}"
        @bots.each do |name, proxy|
          puts
          puts name
          proxy.run_code
          puts proxy.bot.properties[:location]
        end
      end
    end
    
  end

arena = {
  class: Arena, 
  parameters: {
    size: {width: 100, length: 100}
  }
}

bots = [
  { name: "BasicBot1",
    class: BasicBot,
    parameters: {
      arena: arena,
      location: {x: 50, y:50},
      parts: {Brawl::BasicMotor=>{move_max: 3, turn_max: 360}}
    },
    code:<<-CODE
    code do |bot|
      if rand(0) > 0.5
        bot.turn [:right, :left].sample
      end
      bot.move rand(3) + 1
    end
    CODE
  }
]

battle = Brawl::BattleController.new(
  arena: arena, 
  bots: bots
)

battle.run

end














