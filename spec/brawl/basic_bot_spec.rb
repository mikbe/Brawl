require 'spec_helper'

describe Brawl::BasicBot do

  let(:arena){Brawl::Arena.new(size: {width: 100, length: 100})}
  let(:bot) {Brawl::BasicBot.new(arena: arena, location: {x: 0.0, y: 0.0})}

  it "should provide a hash of 'public' properites for the arena" do
    bot.properties.should_not be_nil
  end

  it "should have the methods of the parts that are injected into it" do
    module Foo
      def initialize(params={})
        puts "foo init"
      end
      def bar
      end
    end

    bot = Brawl::BasicBot.new(
      location: {x: 0.0, y: 0.0}, 
      heading: 0, 
      arena: arena, 
      parts: {Foo => {}}
    )
    bot.should respond_to(:bar)
  end
  
end