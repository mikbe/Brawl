class Foo
  
  def initialize
    singleton_class.send :alias_method, :__hook__, :bar
    singleton_class.send :define_method, :bar do |*params|
      puts "no mo ba"
      send :__hook__
    end
  end
  
  def bar
    puts "bar"
  end
  
end

f = Foo.new

f.bar
