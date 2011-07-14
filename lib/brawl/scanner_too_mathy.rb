require 'set'

module Brawl
  class BasicScanner
    include HashableProperties
    
    attr_reader :range, :max_sweep, :bot
    DECIMAL_PLACES  = 5
    
    def initialize(args={})
      set_properties(args)
    end

    # this needs some serious work but, "First make it work, then make it fast."
    def scan(args={})
      
      sweep    = [@max_sweep, args[:sweep] ||= @max_sweep].min
      
      triangle = [@bot.position]
      [
        (Math::PI / 180 ) * (bot.heading - (sweep/2)),
        (Math::PI / 180 ) * (bot.heading + (sweep/2))
      ].each do |radian|
        triangle << {
          x:  @bot.position[:x] + (Math.sin(radian).round(DECIMAL_PLACES) * @range),
          y:  @bot.position[:y] + (Math.cos(radian).round(DECIMAL_PLACES) * @range)
        }
      end
      
      # turn lines into triangles
      if triangle[1] == triangle[2]
        if triangle[0][:x] == triangle[1][:x]
          triangle[2][:x] += 0.99
        else
          triangle[2][:y] += 0.99
        end
      end
      # build wall points
      wall_points = Set.new
      #left and right
      (@bot.arena.height+2).times do |y| 
        wall_points << {x: - 1.0, y: y - 1.0}
        wall_points << {x: @bot.arena.width + 1.0, y: y - 1.0}
      end
      #top & bottom
      (@bot.arena.width+2).times do |x| 
        wall_points << {x: x - 1.0, y: - 1.0}
        wall_points << {x: x - 1.0, y: @bot.arena.height + 1.0}
      end
      found_points = wall_points.to_a.compact.collect{|point| {type: :wall}.merge(point) if point_in_triangle(point, triangle)}

      # enemy points
      enemy_points = @bot.arena.bots.collect {|bot| bot.position unless bot.position == @bot.position}
      unless enemy_points.empty?
        found_points += enemy_points.compact.collect{|point| {type: :enemy}.merge(point) if point_in_triangle(point, triangle)}
      end
      found_points.compact
    end

    private

    def sign(point1, point2, point3)
      (point1[:x] - point3[:x]) * 
      (point2[:y] - point3[:y]) - 
      (point2[:x] - point3[:x]) * 
      (point1[:y] - point3[:y])
    end

    def point_in_triangle(point, triangle)
      b1 = sign(point, triangle[0], triangle[1]) < 0.0
      b2 = sign(point, triangle[1], triangle[2]) < 0.0
      b3 = sign(point, triangle[2], triangle[0]) < 0.0
      
      ((b1 == b2) && (b2 == b3))
    end
  
  end
end