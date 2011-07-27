require 'eventable'

module Brawl

  class BattleController

    include Eventable
    event :bot_msg
    
    attr_accessor :arena, :bots, :clock

    def initialize(params = {})
      super

      arena_data = params[:arena]
      make_arena(arena_data)

      bot_data = params[:bots]
      make_bots(bot_data)

      clock_data = params[:clock]
      make_clock(clock_data)

    end

    def make_arena(arena_data)
      return unless arena_data
      @arena = Brawl::Arena.new(arena_data)
    end

    def make_clock(clock_data)
      return unless clock_data
      @clock = Clock.new(clock_data[:tick_rate])
      @arena.set_clock(clock) if @arena
    end

    def make_bots(bot_data)
      return unless bot_data
      
      @bots = []
      bot_data.each do |bot_datum|
        bot_params = bot_datum[:params]

        bot_params.merge!(arena: arena)

        location = {location: {x: rand(arena.width), y:rand(arena.length)}}
        bot_params.merge!(location)

        bot_instance  = bot_datum[:class].new(bot_params)
        
        bot_instance.register_for_event(
          event:    :bot_ran_method, 
          listener: self, 
          callback: :bot_msg_callback
        )
        bot_instance.register_for_event(
          event:    :bot_damaged, 
          listener: self, 
          callback: :bot_msg_callback
        )

        bot_proxy = BotProxy.new(
          clock:  clock,
          bot:    bot_instance,
          code:   bot_datum[:code]
        )

        @bots << {
          name:  bot_datum[:name],
          proxy: bot_proxy
        }
      end
    end

    def bot_msg_callback(*params, &block)
      puts *params.inspect
      fire_event(:bot_msg, *params, &block)
    end

    def victory?
      arena.victory?
    end

    def start
      @bots.each do |bot|
        bot[:proxy].start
      end
      @clock.start
    end

    def stop
      @clock.stop
    end

  end

end
