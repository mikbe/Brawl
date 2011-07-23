module Brawl

  module BasicMotor
    include BasicPart
    
    attr_reader :move_max, :turn_max
    
    def initialize(params={})
      set :move_max,  2, params
      set :turn_max, 90, params
    end

    def move(count=1)
      count = [count, @move_max].min
      count.times do 
        angle = (Math::PI / 180 ) * heading
        @location[:x] += Math.sin(angle).round(DECIMAL_PLACES)
        @location[:y] += Math.cos(angle).round(DECIMAL_PLACES)
      end
    end

    def turn(params)
      # refactor
      if params.is_a?(Hash)
        turn_to(params[:to_angle])    if params[:to_angle]
        turn_by(params[:by_degrees])  if params[:by_degrees]
      else
        angles = {left: -90, right: 90, around: 180}
        turn_by(angles[params])
      end
    end

    private

    def turn_to(angle)
      turn_by_angle = Helper.wrap_angle(angle - @heading)
      turn_by(turn_by_angle)
    end

    def turn_by(degrees)
      degrees = boundscheck_angle(degrees)
      @heading = (@heading + degrees) % 360
    end
    
    def boundscheck_angle(angle)
      [angle.abs % 360, @turn_max].min * (angle.abs / angle)
    end
    
  end

end