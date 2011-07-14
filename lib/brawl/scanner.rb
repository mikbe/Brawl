require 'set'

module Brawl
  class Scanner
    DECIMAL_PLACES  = 1

    attr_reader :range, :max_sweep, :bot
    
    def initialize(args={})
      args.each {|key, value| instance_variable_set "@#{key}", value}
    end

    # Scan shouldn't be a realistic math based scan looking at exact locations
    # It should create a pixelated triangle where if a pixel is
    # inside the triangle of the scan then the whole pixel is scanned.
    def scan(args={})
      sweep       = [@max_sweep, args[:sweep] ||= @max_sweep].min
      scan_points = Set.new
      
      (1..sweep).each do |angle|
        radian = (Math::PI / 180 ) * (bot.heading - angle)
        @range.times do |distance|
          scan_points << {
            x:  (@bot.position[:x] + (Math.sin(radian).round(DECIMAL_PLACES) * (distance + 1))).floor,
            y:  (@bot.position[:y] + (Math.cos(radian).round(DECIMAL_PLACES) * (distance + 1))).floor
          }
        end
      end
      
      # build wall points
      wall_points = Set.new
      #left and right
      (@bot.arena.height+2).times do |y| 
        wall_points << {x: - 1, y: y - 1}
        wall_points << {x: @bot.arena.width + 1, y: y - 1}
      end
      #top & bottom
      (@bot.arena.width+2).times do |x| 
        wall_points << {x: x - 1, y: - 1}
        wall_points << {x: x - 1, y: @bot.arena.height + 1}
      end
      
      found_points = (wall_points.to_a & scan_points.to_a).collect{|point| {type: :wall}.merge(point)}.compact

      # enemy points
      enemy_points = @bot.arena.bots.collect {|bot| {x: bot.position[:x].floor, y: bot.position[:y].floor} unless bot.position == @bot.position}.compact
      found_points += (enemy_points.to_a & scan_points.to_a).collect{|point| {type: :enemy}.merge(point)}

      found_points
    end
  

    private



    # Figure out how to use this... what is self?
    #
    #
    # def contains_point?(poly, point)
    #   contains_point = false
    #   i = -1
    #   j = self.size - 1
    #   while (i += 1) < self.size
    #     a_point_on_polygon = self[i]
    #     trailing_point_on_polygon = self[j]
    #     if point_is_between_the_ys_of_the_line_segment?(point, a_point_on_polygon, trailing_point_on_polygon)
    #       if ray_crosses_through_line_segment?(point, a_point_on_polygon, trailing_point_on_polygon)
    #         contains_point = !contains_point
    #       end
    #     end
    #     j = i
    #   end
    #   return contains_point
    # end
  
  end
end