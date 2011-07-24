require 'spec_helper'

describe Brawl::Clock do

  let(:clock){Brawl::Clock.new(0.01)}

  it "should start counting" do
    expect{clock.start; sleep(0.05)}.should change(clock, :tick)
    clock.stop
  end

  it "should stop counting" do
    clock.start
    sleep(0.02)
    clock.stop
    sleep(0.01)
    expect{sleep(0.05)}.should_not change(clock, :tick)
  end

  it "should increment 'tick' at the specified interval" do
    clock = Brawl::Clock.new(0.01)
    clock.start
    sleep(0.10)
    clock.stop
    clock.tick.should be_approximately(10).within(1)
  end

end