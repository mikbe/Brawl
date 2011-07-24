module Brawl

  DECIMAL_PLACES  = 1

  class Helper

    def self.to_radian(angle)
      angle * (Math::PI / 180)
    end

    def self.to_degree(angle)
      angle * (180.0 / Math::PI)
    end

    # returns a shorter angle if one exists (angle - 180's complement)
    # e.g. wrap_angle(270)  = -90
    #      wrap_angle(-320) = 40
    #      wrap_angle(45)   = 45
    def self.wrap_angle(angle)
      # refactor? : can this be simplified?
      return angle unless angle > 180 || angle < -180
      (360 - angle.abs) * (angle.abs / angle) * -1
    end

    def self.point_in_cone?(params)

      # the point where the cone starts
      origin    = params[:origin]
      # how long the cone is
      radius    = params[:radius]
      # how wide the cone is
      angle     = params[:angle]
      # the center angle of the cone
      direction = params[:direction]
      # the point under test
      point     = params[:point]

      x1, y1, x2, y2 = origin[:x], origin[:y], point[:x], point[:y]

      # no point in continuing if the target is out of range
      distance = Math.sqrt((x1 - x2)**2 + (y1 - y2)**2)
      return false if distance > radius

      heading_to_target = Math.atan2(x2 - x1, y2 - y1)

      min_cone_angle = to_radian((direction - (angle / 2)) % 360)
      max_cone_angle = to_radian((direction + (angle / 2)) % 360)

      # Check if the heading to the target is inside the scan angle
      if min_cone_angle > max_cone_angle
        heading_to_target >= min_cone_angle ||
         heading_to_target <= max_cone_angle
      else
        heading_to_target >= min_cone_angle && 
          heading_to_target <= max_cone_angle
      end
    end

    def self.points_surrounding_rectangle(width, length)
      points = []
      #left and right
      (length).times do |y| 
        points << {x: - 1, y: y}
        points << {x: width + 1, y: y}
      end
      #top & bottom
      (width+2).times do |x| 
        points << {x: x - 1, y: - 1}
        points << {x: x - 1, y: length + 1}
      end
      points
    end
  end

end