module Brawl
  
  class Bot
    DECIMAL_PLACES  = 1
    
    attr_reader :position, :heading, :arena
    
    def initialize(args={})

      args.each {|key, value| instance_variable_set "@#{key}", value}      

    end
    
    # movement
    
    def move
      angle = (Math::PI / 180 ) * @heading
      @position[:x] += Math.sin(angle).round(DECIMAL_PLACES)
      @position[:y] += Math.cos(angle).round(DECIMAL_PLACES)
    end
    
    # turns
    
    def turn(args)
    
      if args.is_a?(Hash)
        if args[:to_angle]
          turn_to(args[:to_angle])
        elsif args[:by_degrees]
          turn_by(args[:by_degrees])
        end
      else
        angles = {left: -90, right: 90, around: 180}
        turn_by(angles[args])
      end
      
    end
    
    def turn_to(angle)
      @heading = angle
    end
    
    def turn_by(degrees)
      @heading += degrees
      @heading %= 360
    end
    
    # scanning
    
    def scan(args)
      []
    end
    
  end
  
  
end