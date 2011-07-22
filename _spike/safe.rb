class Bar
  def private_parts
    "huge"
  end
end

class Foo
  def initialize
    @bar = Bar.new
    @secret = ["secret"]
  end
  
end

f = Foo.new
vars = []
vars.taint
Thread.start {
  $SAFE = 3
  bar = Bar.new
  f.instance_variable_set :@secret, "hahahaha"
  vars  = f.instance_variable_get(:@secret)
  bar   = f.instance_variable_get(:@bar)
  vars  << "#{vars}, #{bar.private_parts}"
}.join

puts "vars: #{vars}"
puts "Done"