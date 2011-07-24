$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "/../lib"))
require 'brawl'
$DEBUG=true
Thread.abort_on_exception

module Brawl

  class CommandSync

    attr_reader :ticks, :run

    def initialize(min_time=0.5)
      @min_time = min_time
      @run      = :wait
      @ticks    = 0
    end

    def start
      @run = :run
      Thread.start{
        until @run == :stop
          sleep(@min_time)
          #puts "incrementing ticks: #{@ticks}"
          @ticks += 1
        end
        puts "Command sync stopped "
      }
    end
    
    def stop
      @run = :stop
    end

  end

  class Proxy
    
    attr_accessor :bot, :name, :last_tick
    
    def initialize(params)
      @sync = params[:sync]
      
      # probably just put this all in one object
      @name = params[:name]
      @bot  = params[:bot]
      @code = params[:code]
      
      @last_tick = @sync.ticks
      @run = false
      add_proxy_methods
    end

    def add_proxy_methods
      puts "proxy: #{@bot.public_methods(false)}"
      @bot.public_methods(false).each do |method|
        singleton_class.send :define_method, method do |*params, &block|
          puts "#{@name}: #{method}(#{params.join})"
          sleep(0.01) while @sync.ticks <= @last_tick
          @last_tick = @sync.ticks
          @bot.send method, *params, &block
          puts "#{@name}: #{@bot.properties[:location]}"
        end
      end
    end

    def start
      @run = true
      # for security in produciton will use a process fork but for now...
      Thread.start {
        # wait for command sync to start
        until @sync.run == :stop || !@run
          sleep(0.01) if @sync.run == :wait
          if @sync.run == :run
            instance_eval("Thread.start{$SAFE=3;#{@code}}.join")
          end
        end
        puts "#{@name} stopped"
        @run = false
      }
    end

    def stop
      @run = false
    end

    def code
      yield self
    end

  end
  
  class BattleController
    
    attr_accessor :arena, :bots
    
    def initialize(params)
      super
      
      @sync = CommandSync.new(params[:min_tick])
      
      arena = params[:arena]
      bots  = params[:bots]
      @arena = arena[:class].new(arena[:parameters])
      
      @bot_proxies = []
      bots.each do |bot|
        puts "add: #{bot[:name]}, #{bot[:class]}"
        bot[:parameters].merge!(location: {x: rand(100), y:rand(100)})
        
        bot_instance = bot[:class].new(bot[:parameters].merge(arena: @arena))
        @bot_proxies << {
          name:  bot[:name],
          proxy: Proxy.new(
            sync: @sync,
            bot:  bot_instance,
            code: bot[:code],
            name: bot[:name]
          )
        }
      end
    end
    
    def start
      @bot_proxies.each do |bot|
        puts
        puts "Starting: #{bot[:name]}"
        bot[:proxy].start
      end
      @sync.start
    end
    
    def stop
      @sync.stop
    end
    
  end

arena = {
  class: Arena, 
  parameters: {
    size: {width: 100, length: 100}
  }
}

bot_code = <<-CODE
code do |bot|
  if rand(0) > 0.5
    bot.turn [:left,:right,:around].sample
  end
  bot.move rand(3) + 1
end
CODE

bots = [
  { name: "BasicBot1",
    class: BasicBot,
    parameters: {
      arena: arena,
      parts: {Brawl::BasicMotor=>{move_max: 3, turn_max: 360}}
    },
    code:bot_code
  },
  { name: "BasicBot2",
    class: BasicBot,
    parameters: {
      arena: arena,
      parts: {Brawl::BasicMotor=>{move_max: 3, turn_max: 360}}
    },
    code:bot_code
  }
]

battle = Brawl::BattleController.new(
  arena: arena, 
  bots: bots,
  min_tick: 0.01
)

battle.start

timeout = Time.now + 5
while Time.now <= timeout
  sleep(0.1)
end
battle.stop
sleep(1)

end














