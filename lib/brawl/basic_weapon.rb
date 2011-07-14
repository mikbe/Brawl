module Brawl
  class BasicWeapon
    include HashableProperties
    
    attr_reader :range, :reload_time, :power
    
    def initialize(args={})
      set_properties(args)
      
      @reload_time      ||= 2.0
      @reload_countdown   = Time.now
    end
     
    def fire(direction)
      return nil if ([:at, :relative] & direction.keys).empty?
      @reload_countdown = Time.now + @reload_time
      
      true
    end
    
    def reload_countdown
      return 0.0 if @reload_countdown <= Time.now
      @reload_countdown - Time.now
    end
    
  end
end