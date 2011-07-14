module HashableProperties
  def set_properties(args={})
    args.each do |property, value|
      instance_variable_set("@#{property}", value) if public_methods(false).include? property
    end
  end
end
