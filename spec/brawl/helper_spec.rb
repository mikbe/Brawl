require 'spec_helper'

describe Brawl::Helper do

  let(:helper){Brawl::Helper}

  context "when wrapping angles" do

    # no change
    it {helper.wrap_angle(45).should == 45.0}
    it {helper.wrap_angle(179).should == 179.0 }
    it {helper.wrap_angle(-40).should == -40.0}
    it {helper.wrap_angle(-179).should == -179.0 }

    # complement angle, "Have you been working out? You look less obtuse!"
    it {helper.wrap_angle(270).should == -90.0 }
    it {helper.wrap_angle(-320).should == 40.0 }
    it {helper.wrap_angle(-280).should == 80.0 }
    it {helper.wrap_angle(185).should == -175.0 }

  end

end