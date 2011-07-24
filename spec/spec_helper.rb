$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "/../lib"))
$: << '.'

require 'rspec'
require 'brawl'

RSpec::Matchers.define :be_approximately do |approx|
  match do |actual|
    !!((approx - @accuracy)..(approx + @accuracy)).include?(actual)
  end

  chain :within do |accuracy| 
    @accuracy = accuracy
  end

  failure_message_for_should do |actual|
    "expected #{actual} to be about #{approx}" +
    " (between #{approx - @accuracy} and #{approx + @accuracy})"
  end
    
end