module Brawl
  
  class Arena
    
    attr_reader :size, :clock
    
    def initialize(params={})
      @size     = params[:size]
      @objects  = []
      
      set_clock(params[:clock])

      add_walls
    end

    def length
      @size[:length]
    end

    def width
      @size[:width]
    end

    def ticks
      @clock.ticks
    end

    def set_clock(clock=nil)
      @clock = clock || Clock.new
      @clock.start
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

    # allows searching by object properties like location or id
    def get_object(property_hash)
      property, value = property_hash.first
      @objects.each do |object|
        return object.properties if object.properties[property] == value
      end
      nil
    end

    def get_all_objects
      @objects.collect {|object| object.properties}
    end

    def in_bounds?(location)
      return false if location[:x] >= @size[:width]  || location[:x] <  0
      return false if location[:y] >= @size[:length] || location[:y] <  0
      true
    end

    def ping(location)
      get_object(location: location)
    end

    def forward_damage(params)
      target = @objects.select{|object| object.id == params[:target]}.first
      target.damage(params[:damage])
      end_game if victory?
    end

    def victory?
      @objects.one? do |object|
        object.class != Wall && object.health > 0
      end
    end

    def end_game
      @clock.stop
    end

    private 

    def add_walls
      (0...width).each do |col|
        @objects << Wall.new(location: {x: col, y: -1})
        @objects << Wall.new(location: {x: col, y: length})
      end
      (0...length).each do |row|
        @objects << Wall.new(location: {x: -1, y: row})
        @objects << Wall.new(location: {x: width, y: row})
      end
    end

  end
  
end