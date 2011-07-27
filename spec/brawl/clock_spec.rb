require 'spec_helper'

describe Brawl::Clock do

  let(:clock){Brawl::Clock.new(0.01)}

  it "should start counting" do
    expect{clock.start; sleep(0.05)}.should change(clock, :ticks)
    clock.stop
  end

  it "should stop counting" do
    clock.start
    sleep(0.02)
    clock.stop
    sleep(0.01)
    expect{sleep(0.05)}.should_not change(clock, :ticks)
  end

  it "should increment 'tick' at the specified interval" do
    clock = Brawl::Clock.new(0.01)
    clock.start
    sleep(0.10)
    clock.stop
    clock.ticks.should be_within(1.1).of(10)
  end

end