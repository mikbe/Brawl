require 'uuidtools'

module Brawl

  class BasicArenaObject

    attr_reader   :id
    attr_accessor :location, :heading, :health

    def initialize(params={})
      set :id, UUIDTools::UUID.timestamp_create.to_s, params
      #set :location, {x: 0, y: 0}, params
      #set :heading, 0, params
      set :health, 1, params
      @heading = params[:heading] || 0
      @location = params[:location] || {x: 0, y: 0}
      set :properties, [:id, :class, :location, :heading]
    end

    # properties are values that are OK to be publicly 'seen' in the arena
    def properties
      @properties.each_with_object({}) do |property, hash|
        hash[property] = self.send(property)
      end
    end
    
    protected
    
    def set(property, default, params={})
      instance_variable_set("@#{property}", params[property] || default)
    end

  end

end