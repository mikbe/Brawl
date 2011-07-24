require 'uuidtools'

module Brawl

  class BasicArenaObject

    attr_reader   :id, :clock
    attr_accessor :location, :heading, :health

    def initialize(params={})
      set :clock, nil, params
      set :id, UUIDTools::UUID.timestamp_create.to_s, params
      set :location, {x: 0, y: 0}, params
      set :heading, 0, params
      set :health, 1, params
      set :properties, [:id, :class, :location, :heading]
    end

    # properties are values that are OK to be publicly 'seen' in the arena
    def properties
      @properties.each_with_object({}) do |property, hash|
        hash[property] = self.send(property)
      end
    end
    
    def damage(hitpoints)
      @health -= hitpoints
      @health < 0 ? @health = 0 : @health
    end
    
    protected
    
    def set(property, default, params={})
      instance_variable_set("@#{property}", params[property] || default)
    end

  end

end