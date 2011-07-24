module Brawl
  
  class Clock
    
    attr_reader :tick_rate, :tick
    
    def initialize(tick_rate=0.05)
      @tick_rate = tick_rate
      @state = :stopped
      @tick = 0
    end
    
    def start
      @state = :running
      ticking
    end
    
    def stop
      @state = :stopping
    end
    
    private
    
    def ticking
      Thread.start {
        while @state == :running
          sleep(@tick_rate)
          @tick += 1
        end
        @state = :stopped
      }
    end
    
  end
  
end