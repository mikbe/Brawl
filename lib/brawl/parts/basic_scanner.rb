module Brawl
  module BasicScanner
    
    attr_reader :scan_max, :angle_max

    DECIMAL_PLACES  = 1
    
    def initialize(params={})
      @scan_max   = params[:scan_max] || 10
      @angle_max  = params[:angle_max] || 45
    end

    def scan(params={})
      angle = [@angle_max, params[:angle] ||= @angle_max].min

      cone = {
        origin:     @location,
        direction:  params[:direction],
        radius:     @scan_max,
        angle:      angle,
      }

      @arena.get_all_objects.collect do |info_hash|
        next if info_hash[:id] == @id 
        if obj = Helper.point_in_cone?(cone.merge(point: info_hash[:location]))
          info_hash.merge(obj)
        end
      end.compact
      
    end
  
  end
end