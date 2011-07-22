module Brawl
  
  class Arena
    
    attr_reader :width, :height
    
    def initialize(params={})
      @width  = params[:width]
      @height = params[:height]
      @field  = {}
    end

    def add_object(object_position_hash)
      add_objects(object_position_hash).first
    end
    
    def add_objects(object_position_array)
      object_position_array.collect do |object, position|
        ping(position) ? false : !!(@field[object] = position)
      end
    end

    # For now this uses to_s but it might be better to wrap up
    # public properties of an object into a hash to allow easier
    # use of the return data. 
    # Or maybe a mixin that adds object#public_properties that can be set.
    def ping(position)
      @field.each do |object, location|
        return object.to_s if location == position
      end
      nil
    end

  end
  
end