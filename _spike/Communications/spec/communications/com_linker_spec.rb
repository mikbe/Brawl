require 'spec_helper'

describe Brawl::Communications::Linker do

  it "should link two classes using a communication class"

end

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