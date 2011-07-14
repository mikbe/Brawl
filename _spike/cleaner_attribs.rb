class Foo
  attr_accessor :bar
  def initialize(args={})
    args.each do |key, value|
      instance_variable_set("@#{key}", value) if public_methods(false).include? key
    end
  end
end

puts Foo.instance_methods(false)

f = Foo.new(bar: "foo!")
puts f.bar