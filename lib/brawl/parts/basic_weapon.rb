module Brawl
  module BasicWeapon
    include BasicPart
    
    attr_reader :range, :reload_time, :power
    
    def initialize(params={})
      set :reload_time, 10, params
      set :range, 10, params
      set :power, 1, params

      @reload_countdown = 0
    end

    def shoot(direction=@heading)
      return false if reload_countdown > 0
      @reload_countdown = @reload_time + @arena.tick
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

      # refactor 
      hit = possible_hits.sort{|a,b| a[:distance] <=> b[:distance]}.first
      @arena.forward_damage(damage: @power, target: hit[:id])
      hit
    end

    def reload_countdown
      return 0 if @reload_countdown <= @arena.tick
      @reload_countdown - @arena.tick
    end
    
  end
end