require 'forwardable'
require 'uuidtools'
require 'eventable'

module Brawl

  class BasicBot < BasicArenaObject
    extend Forwardable

    include Eventable
    event :bot_ran_method
    event :bot_damaged

    attr_reader :parts

    DECIMAL_PLACES = 1

    def initialize(params={})
      @arena = params[:arena]
      @parts = params[:parts]

      add_parts(@parts, params)
      hook_methods_for_listeners

      super

      @arena.add_object(self)
    end

    def damage(damage_points)
      super
      fire_event(:bot_damaged,
        properties,
        :damage,
        damage_points
      )
      @arena.remove_object(self) if @health <= 0
    end

    private

    def add_parts(parts, params)
      return unless parts
      parts.each do |part_module, init_params|
        params.merge! init_params
        # make sure we can fire the module's initialize method
        part_module.send :alias_method, :initialize_parts, :initialize
        extend part_module
        initialize_parts(params)
      end
    end

    def hook_methods_for_listeners
      public_methods(false).each do |method|
        next if [:properties,:damage].include?(method)
        singleton_class.send :alias_method, "_hook_#{method}", method

        singleton_class.send :define_method, method do |*params, &block|
          return if @health <= 0
          fire_event(:bot_ran_method, properties, method, *params)
          send "_hook_#{method}".to_sym, *params, &block
        end

      end
    end

  end

end
