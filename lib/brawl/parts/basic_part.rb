module Brawl

  module BasicPart
    protected

    def set(property, default, params={})
      instance_variable_set("@#{property}", params[property] || default)
    end
  end

end