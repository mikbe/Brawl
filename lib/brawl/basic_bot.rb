require 'forwardable'

module Brawl
  
  class BasicBot
    extend Forwardable
    include HashableProperties
    
    attr_reader :position, :heading, :arena, :parts

    DECIMAL_PLACES  = 1
    
    def initialize(args={})
      set_properties(args)
      
      # Add parts's methods to the bot class dynamically
      # makes it super easy to extend the bot with new parts!
      @parts.each do |part, instance|
        instance_variable_set("@#{part}", instance)
        self.class.def_delegators "@#{part}", *(instance.public_methods(false))
      end if @parts
    
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
    
  end
  
  
end