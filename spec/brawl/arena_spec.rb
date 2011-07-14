require 'spec_helper'

describe Brawl::Arena do

  it "should initizlize properties using a hash" do
    Brawl::Arena.new(height: 100).height.should == 100
  end

end