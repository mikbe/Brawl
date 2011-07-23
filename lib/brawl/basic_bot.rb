require 'forwardable'
require 'uuidtools'

module Brawl
  
  class BasicBot < Brawl::BasicArenaObject

    extend Forwardable

    attr_reader :parts

    DECIMAL_PLACES = 1

    def initialize(params={})
      set :arena, nil, params
      set :parts, nil, params

      add_parts(@parts, params)

      super

      @arena.add_object(self)
    end

    # properties that can be 'seen' in the arena
    def properties
      @properties.each_with_object({}) do |property, hash|
        hash[property] = self.send(property)
      end
    end

    private

    def add_parts(parts, params)
      return unless parts
      parts.each do |part_module, init_params|
        params.merge! init_params
        part_module.send :alias_method, :initialize_parts, :initialize
        extend part_module
      end
      initialize_parts(params)
    end

    def initialize_parts(params)
      super
    end
    
  end

end