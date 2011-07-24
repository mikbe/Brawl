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

    def scan(params={})
      angle       = [@angle_max, params[:angle] ||= @angle_max].min
      contacts    = []

      cone = {
        origin:     @location,
        direction:  params[:direction],
        radius:     @scan_max,
        angle:      angle,
      }

      @arena.get_all_objects.each do |object|
        unless object[:id] == @id
          if Helper.point_in_cone?(cone.merge(point: object[:location]))
            contacts << object
          end
        end
      end

      contacts
    end
  
  end
end