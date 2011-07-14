module Brawl
  
  class MathHelper

    def self.point_in_cone?(args)
      radius, angle, direction, origin, point = args[:radius], args[:angle], args[:direction], args[:origin], args[:point]
      x1, y1, x2, y2 = origin[:x], origin[:y], point[:x], point[:y]
      
      # Is the distance between the origin and the target is <= to the scan range?
      distance = Math.sqrt((x1 - x2)**2 + (y1 - y2)**2)
      return false if distance > radius

      heading_to_target = Math.atan2(x2 - x1, y2 - y1)

      min_cone_angle = (Math::PI / 180) * ((direction - (angle / 2)) % 360)
      max_cone_angle = (Math::PI / 180) * ((direction + (angle / 2)) % 360)

      # Now check if the ray from the origin to the target is inside the scan angle.
      if min_cone_angle > max_cone_angle
        heading_to_target >= min_cone_angle || heading_to_target <= max_cone_angle
      else
        heading_to_target >= min_cone_angle && heading_to_target <= max_cone_angle
      end
    end
    
    def self.points_surrounding_rectangle(width, height)
      points = []
      #left and right
      (height).times do |y| 
        points << {x: - 1, y: y}
        points << {x: width + 1, y: y}
      end
      #top & bottom
      (width+2).times do |x| 
        points << {x: x - 1, y: - 1}
        points << {x: x - 1, y: height + 1}
      end
      points
    end

    
  end
end