module Brawl

  class BotProxy

    attr_accessor :bot, :last_tick, :msg_log, :clock

    def initialize(params)
      @clock      = params[:clock]
      @bot        = params[:bot]
      @code       = params[:code]

      @last_tick  = @clock.ticks
      @run        = false

      add_proxy_methods
    end

    def name
      @bot.name
    end

    def add_proxy_methods
      # I'm sure there's a better way of doing this
      combined_methods = @bot.public_methods(false)
      combined_methods.concat BasicArenaObject.instance_methods(false)

      combined_methods.each do |method|
        next if method.to_s[0] == "_"
        singleton_class.send :define_method, method do |*params, &block|
          sleep(0.01) while @clock.ticks <= @last_tick
          @last_tick = @clock.ticks
          @bot.send method, *params, &block
        end

      end
    end

    def start
      @run = true
      Thread.start {
        until @clock.state == :stopped || !@run
          sleep(0.01) if @clock.state == :wait
          if @clock.state == :running
            instance_eval("Thread.start{$SAFE=3;#{@code}}.join")
          end
        end
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
end
