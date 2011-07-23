module Brawl
  
  class Arena
    
    attr_reader :size, :objects
    
    def initialize(params={})
      @size     = params[:size]
      @objects  = []
    end

    def length
      @size[:length]
    end

    def width
      @size[:width]
    end

    def add_object(object)
      add_objects([object]).first
    end
    
    def add_objects(objects_array)
      objects_array.collect do |object|
        next !!(@objects << object) unless 
          get_object(id: object.id) || 
          ping(object.location)
        false
      end
    end

    def remove_object(object)
      @objects.delete(object)
    end

    def move_object(object_location_hash)
      object    = object_location_hash.keys.first
      location  = object_location_hash.values.first

      return if ping(location)
      return unless in_bounds?(location)

      !!(object.location = location)
    end

    # I think this might be able to change to the object itself
    def get_object(property_hash)
      property, value = property_hash.first
      @objects.each do |object|
        return object.properties if object.properties[property] == value
      end
      nil
    end

    def in_bounds?(location)
      return false if location[:x] >= @size[:width]  || location[:x] <  0
      return false if location[:y] >= @size[:length] || location[:y] <  0
      true
    end
    
    def ping(location)
      get_object(location: location)
    end

  end
  
end