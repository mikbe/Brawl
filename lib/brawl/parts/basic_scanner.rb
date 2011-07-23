require 'set'

module Brawl
  module BasicScanner
    include BasicPart
    
    attr_reader :scan_max, :angle_max

    DECIMAL_PLACES  = 1
    
    def initialize(params={})
      set :scan_max, nil, params
      set :angle_max, nil, params
    end

    def scan(args={})
      angle       = [@angle_max, args[:angle] ||= @angle_max].min
      direction   = args[:direction]

      # cone = {
      #   origin: @location, 
      #   direction: @heading, 
      #   radius: @range, 
      #   angle: angle
      # }
      # 
      # get_all_objects


      # refactor
      # {wall: wall_points, enemy: enemy_points}.collect do |type, point_set|
      #   point_set.collect do |point|
      #     if Helper.point_in_cone?({point: point}.merge(cone))
      #       {type: type}.merge(point)
      #     end
      #   end.compact
      # end.flatten
      
    end
  
  end
end