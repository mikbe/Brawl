module Brawl
  class BasicWeapon
    
    attr_reader :range, :reload_time, :power, :bot
    
    def initialize(params={})
      @reload_time  = params[:reload_time]
      @range        = params[:range]
      @power        = params[:power]
      @bot          = params[:bot]

      @reload_time      ||= 2.0
      @reload_countdown   = Time.now
    end
     
    def fire(aim)
      
      # refactor
      case aim.keys.first
        when :at
          direction = aim[:at]
        when :relative
          direction = aim[:relative] + @bot.heading
        else
          return nil     
      end

      @reload_countdown = Time.now + @reload_time
      
      # refactor
      # cut and paste tells me this probably belongs somewhere else
      enemy_points = @bot.arena.bots.collect do |bot| 
        unless bot.position == @bot.position
          { x: bot.position[:x].floor,  
            y: bot.position[:y].floor}
        end
      end.compact

      cone = {
        origin: @bot.position, 
        direction: direction, 
        radius: @range, 
        angle: 1
      }

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