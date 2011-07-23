class Foo
  def bar(value)
    "doh!"
  end
  def baz(value1, value2)
    "Oh, noos!"
  end
  def qux
    "Fudge!"
  end
  def quux(value1, value2, &block)
    "Nope, nope, nope"
  end
end

class FooProxy
  def bar(value)
    "#{value}"
  end
  def baz(value1, value2)
    "#{value1}, #{value2}"
  end
  def qux
    yield "FooProxy"
  end
  def quux(value1, value2, &block)
    yield ["FooProxy", "#{value1}, #{value2}"]
  end
end

class NullModem
  def link_method(client, server, method)
    client.class.send :define_method, method do |*params, &block|
      server.send method, *params, &block
    end
  end
end

class ComLinker
  def self.link(comlayer, client, server)
    client.public_methods(false).each do |method|
      comlayer.link_method(client, server, method)
    end
  end
end


foo = Foo.new
proxy = FooProxy.new
comlayer = NullModem.new

ComLinker.link(comlayer, foo, proxy)

puts foo.bar("hello!")
puts foo.baz("howdy", "ho")
puts foo.qux {|value| value}
puts (foo.quux("look", "at this") {|value| value}).inspect




