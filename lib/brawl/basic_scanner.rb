require 'set'

module Brawl
  class BasicScanner

    attr_reader :range, :max_angle, :bot

    DECIMAL_PLACES  = 1
    
    def initialize(params={})
      @range      = params[:range]
      @max_angle  = params[:max_angle]
      @bot        = params[:bot]
    end

    def scan(args={})
      angle       = [@max_angle, args[:angle] ||= @max_angle].min
      direction   = args[:direction]
      
      enemy_points = bot.arena.bots.collect do |bot| 
        { x: bot.position[:x].floor, 
          y: bot.position[:y].floor
        } unless bot.position == @bot.position
      end.compact

      wall_points = Brawl::MathHelper.points_surrounding_rectangle(
        bot.arena.width, 
        bot.arena.height
      )

      cone = {
        origin: bot.position, 
        direction: direction, 
        radius: @range, 
        angle: angle
      }

      # refactor
      {wall: wall_points, enemy: enemy_points}.collect do |type, point_set|
        point_set.collect do |point|
          if Brawl::MathHelper.point_in_cone?({point: point}.merge(cone))
            {type: type}.merge(point)
          end
        end.compact
      end.flatten
      
    end
  
  end
end