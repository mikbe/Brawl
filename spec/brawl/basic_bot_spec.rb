require 'spec_helper'

describe Brawl::BasicBot do

  let(:arena){Brawl::Arena.new(size: {width: 100, length: 100})}
  let(:bot) {Brawl::BasicBot.new(arena: arena, location: {x: 0.0, y: 0.0})}

  it "should provide a hash of 'public' properites for the arena" do
    bot.properties.should_not be_nil
  end

  it "should have the methods of the parts that are injected into it" do
      bot = Brawl::BasicBot.new(
      location: {x: 0.0, y: 0.0},
      heading: 0,
      arena: arena,
      parts: {Foo => {baz: "Baz set"}}
    )
    bot.should respond_to(:bar)
  end

  it "should access properties of the instance" do
      bot = Brawl::BasicBot.new(
      location: {x: 53.0, y: 34.0},
      heading: 0,
      arena: arena,
      parts: {Foo => {baz: "Baz set"}}
    )
    bot.bar.should == {x: 53.0, y: 34.0}
  end

  it "should initialize parts" do
      bot = Brawl::BasicBot.new(
      location: {x: 0.0, y: 0.0},
      heading: 0,
      arena: arena,
      parts: {Foo => {baz: "Baz set"}}
    )
    bot.baz.should == "Baz set"
  end

  it "should initialize more than one part" do
      bot = Brawl::BasicBot.new(
      location: {x: 0.0, y: 0.0},
      heading: 0,
      arena: arena,
      parts: {Foo => {baz: "Baz set"}, Qux => {quux: "Quux set"}}
    )
    bot.quux.should == "Quux set"
  end

  it "should have methods of more than one part" do
      bot = Brawl::BasicBot.new(
      location: {x: 11.0, y: 222.0},
      heading: 0,
      arena: arena,
      parts: {Foo => {baz: "Baz set"}, Qux => {quux: "Quux set"}}
    )
    bot.phoo.should == {x: 11.0, y: 222.0}
  end


end

module Foo
  attr_accessor :baz
  def initialize(params={})
    @baz = params[:baz]
  end
  def bar
    @location
  end
end

module Qux
  attr_accessor :quux
  def initialize(params={})
    @quux = params[:quux]
  end
  def phoo
    @location
  end
end


