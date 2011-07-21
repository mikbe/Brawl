require 'forwardable'

module Brawl
  
  class BasicBot
    extend Forwardable
    
    attr_reader :position, :heading, :arena, :parts

    DECIMAL_PLACES  = 1
    
    def initialize(params={})
      @position = params[:position]
      @heading  = params[:heading]
      @arena    = params[:arena]
      @parts    = params[:parts]
      
      # Add parts's methods to the bot class dynamically
      # this is how the game functionality will be expanded
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
    
      # refactor
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