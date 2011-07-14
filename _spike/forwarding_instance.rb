require 'forwardable'

class Bar
  def baz
    puts "baz!"
  end
end

class Foo
  extend Forwardable
  
  attr_accessor :parts
  
  def initialize(args)
    
    @parts = args[:parts]

    @parts.each do |part, instance|
      instance_variable_set("@#{part}", instance)
      self.class.def_delegators "@#{part}", *(instance.public_methods(false))
    end
    
  end
  
end


f = Foo.new(parts: {bar: Bar.new})
puts f.public_methods(false)
puts
puts f.instance_variables
f.baz