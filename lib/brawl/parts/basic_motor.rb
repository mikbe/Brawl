module Brawl

  module BasicMotor
    include BasicPart
    
    attr_reader :max_move, :max_turn
    
    def initialize(params={})
      puts
      puts "init called"
      set :max_move,  2, params
      set :max_turn, 90, params
      puts "max_move: #{@max_move}"
      super
    end
    
    # movement
    def move(count=1)
      count.times do 
        angle = (Math::PI / 180 ) * @heading
        @location[:x] += Math.sin(angle).round(DECIMAL_PLACES)
        @location[:y] += Math.cos(angle).round(DECIMAL_PLACES)
      end
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