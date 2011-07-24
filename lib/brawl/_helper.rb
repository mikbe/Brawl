module Brawl

  DECIMAL_PLACES  = 1

  class Helper

    def self.to_radians(angle)
      angle * (Math::PI / 180)
    end

    def self.to_degrees(angle)
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
      distance_to_target = distance(origin, point)
      return false if distance_to_target > radius

      bearing_to_target = Math.atan2(x2 - x1, y2 - y1)

      min_cone_angle = to_radians((direction - (angle / 2)) % 360)
      max_cone_angle = to_radians((direction + (angle / 2)) % 360)

      # Check if the heading to the target is inside the scan angle
      greater_than = bearing_to_target >= min_cone_angle
      less_than    = bearing_to_target <= max_cone_angle

      if (min_cone_angle > max_cone_angle && (greater_than || less_than)) ||
        (min_cone_angle <= max_cone_angle && (greater_than && less_than))
        
        { distance: distance_to_target.round(DECIMAL_PLACES), 
          bearing: to_degrees(bearing_to_target)} 
        
      end
    end

    def self.distance(point1, point2)
      x1, y1, x2, y2 = point1[:x], point1[:y], point2[:x], point2[:y]
      distance = Math.sqrt((x1 - x2)**2 + (y1 - y2)**2)
    end

  end

end