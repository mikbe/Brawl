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

      cone = {
        origin:     @location,
        direction:  params[:direction],
        radius:     @scan_max,
        angle:      angle,
      }

      @arena.get_all_objects.select do |object|
        object[:id] != @id &&
          Helper.point_in_cone?(cone.merge(point: object[:location]))
      end
      
    end
  
  end
end