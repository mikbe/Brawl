module Brawl
  class BasicWeapon
    include HashableProperties
    
    attr_reader :range, :reload_time, :power, :bot
    
    def initialize(args={})
      set_properties(args)
      @reload_time      ||= 2.0
      @reload_countdown   = Time.now
    end
     
    def fire(aim)
      
      case aim.keys.first
        when :at
          direction = aim[:at]
        when :relative
          direction = aim[:relative] + @bot.heading
        else
          return nil     
      end

      @reload_countdown = Time.now + @reload_time

      # cut and past tells me this probaly belongs somewhere else
      enemy_points = @bot.arena.bots.collect do |bot| 
        {x: bot.position[:x].floor, y: bot.position[:y].floor} unless bot.position == @bot.position
      end.compact

      cone = {origin: @bot.position, direction: direction, radius: @range, angle: 1}

      enemy_points.any? do |point|
        Brawl::MathHelper.point_in_cone?({point: point}.merge(cone))
      end
      
    end
    
    def reload_countdown
      return 0.0 if @reload_countdown <= Time.now
      @reload_countdown - Time.now
    end
    
  end
end