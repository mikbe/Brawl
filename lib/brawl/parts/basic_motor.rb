module Brawl

  module BasicMotor
    
    attr_reader :move_max, :turn_max
    
    def initialize(params={})
      @move_max = params[:move_max] || 5
      @turn_max = params[:turn_max] || 90
    end

    def move(count=1)

      heading_radian = Helper.to_radians((@heading + (count < 0 ? 180 : 0)))
      count = count.abs
      count = [count, @move_max].min
      
      count.times do 
        x = @location[:x] + Math.sin(heading_radian).round(DECIMAL_PLACES)
        y = @location[:y] + Math.cos(heading_radian).round(DECIMAL_PLACES)
        break unless @arena.in_bounds?({x: x, y: y})
        @location[:x], @location[:y] = x, y
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