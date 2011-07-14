require 'set'

module Brawl
  class BasicScanner
    include HashableProperties

    attr_reader :range, :max_sweep, :bot

    DECIMAL_PLACES  = 1
    
    def initialize(args={})
      set_properties(args)
    end

    # Scans shouldn't be super accurate math based, looking at exact locations,
    # but instead a scan should use a pixelated triangle so if a "pixel" is 
    # inside the triangle of the scan then the whole pixel is part of the scan.
    # Pixels equate to a 1x1 block on the map.
    # 
    # Wider scans should take longer, figure that out when you get to running bots together
    def scan(args={})
      sweep       = [@max_sweep, args[:sweep] ||= @max_sweep].min
      scan_points = pixelated_cone( sweep: sweep, 
                                        heading: bot.heading, 
                                        x: bot.position[:x], 
                                        y: bot.position[:y]
                                      )
      
      enemy_points = bot.arena.bots.collect do |bot| 
        {x: bot.position[:x].floor, y: bot.position[:y].floor} unless 
          bot.position == @bot.position
      end.compact

      wall_points = points_surrounding_rectangle(bot.arena.width, bot.arena.height)
      
      found_points = (wall_points & scan_points).collect{|point| {type: :wall}.merge(point)}
      found_points += (enemy_points & scan_points).collect{|point| {type: :enemy}.merge(point)}
    end
  
    private
    
    # This will be needed by the weapon
    def pixelated_cone(args)
      sweep, heading, x, y = args[:sweep], args[:heading], args[:x], args[:y]
      scan_points = []
      sweep.times do |angle|
        radian = (Math::PI / 180) * ((angle - (sweep / 2)) + heading)
        (@range+1).times do |distance|
          scan_points << {
            x:  (x + (Math.sin(radian).round(DECIMAL_PLACES) * distance)).floor,
            y:  (y + (Math.cos(radian).round(DECIMAL_PLACES) * distance)).floor
          }
        end
      end
      scan_points.uniq
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