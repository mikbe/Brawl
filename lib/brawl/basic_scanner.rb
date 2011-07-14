require 'set'

module Brawl
  class BasicScanner
    include HashableProperties

    attr_reader :range, :max_angle, :bot

    DECIMAL_PLACES  = 1
    
    def initialize(args={})
      set_properties(args)
    end

    def scan(args={})
      angle       = [@max_angle, args[:angle] ||= @max_angle].min
      direction   = args[:direction]
      
      enemy_points = bot.arena.bots.collect do |bot| 
        {x: bot.position[:x].floor, y: bot.position[:y].floor} unless bot.position == @bot.position
      end.compact

      wall_points = points_surrounding_rectangle(bot.arena.width, bot.arena.height)

      cone = {origin: bot.position, direction: direction, radius: @range, angle: angle}

      {wall: wall_points, enemy: enemy_points}.collect do |type, point_set|
        point_set.collect do |point|
          {type: type}.merge(point) if point_in_cone?({point: point}.merge(cone))
        end.compact
      end.flatten
    end
  
    private
    
    def point_in_cone?(args)
      radius, angle, direction, origin, point = args[:radius], args[:angle], args[:direction], args[:origin], args[:point]
      x1, y1, x2, y2 = origin[:x], origin[:y], point[:x], point[:y]
      
      # Measure if the distance between origin and the target is <= to the scan range,
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

    def points_surrounding_rectangle(width, height)
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