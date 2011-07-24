module Brawl
  module BasicWeapon
    include BasicPart
    
    attr_reader :range, :reload_time, :power
    
    def initialize(params={})
      set :reload_time, 10, params
      set :range, 10, params
      set :power, 1, params

      #@reload_countdown = Time.now
    end

    def shoot(direction)

      cone = {
        origin: @location, 
        direction: direction, 
        radius: @range, 
        angle: 1
      }

      # refactor
      possible_hits = @arena.get_all_objects.collect do |object|
        if object[:id] != @id &&
          hit = Helper.point_in_cone?(cone.merge(point: object[:location]))
            object.merge(hit)
        end
      end.compact
      return if possible_hits.empty?

      possible_hits.sort{|a,b| a[:distance] <=> b[:distance]}.first

    end

      # refactor
      # case aim.keys.first
      #   when :at
      #     direction = aim[:at]
      #   when :relative
      #     direction = aim[:relative] + @bot.heading
      #   else
      #     return nil     
      # end
      # 
      # @reload_countdown = Time.now + @reload_time
      # 
      # # refactor
      # # cut and paste tells me this probably belongs somewhere else
      # enemy_points = @bot.arena.bots.collect do |bot| 
      #   unless bot.location == @bot.location
      #     { x: bot.location[:x].floor,  
      #       y: bot.location[:y].floor}
      #   end
      # end.compact
      # 
      # cone = {
      #   origin: @bot.location, 
      #   direction: direction, 
      #   radius: @range, 
      #   angle: 1
      # }
      # 
      # enemy_points.any? do |point|
      #   Brawl::MathHelper.point_in_cone?({point: point}.merge(cone))
      # end
      
    # end
    
    # def reload_countdown
    #   return 0.0 if @reload_countdown <= Time.now
    #   @reload_countdown - Time.now
    # end
    
  end
end