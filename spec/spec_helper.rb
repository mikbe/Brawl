$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "/../lib"))
$: << '.'

require 'rspec'
require 'brawl'

# RSpec::Matchers.define :be_approximately do |approximate_value|
#   match do |actual|
#     (actual > approximate_value - @accuracy) && 
#     (actual < approximate_value + @accuracy)
#   end
# 
#   chain :within do |accuracy| 
#     @accuracy = accuracy
#   end
# 
#   failure_message_for_should do |actual|
#     "expected #{actual} to be about #{approximate_value}" +
#     " (between #{approximate_value - @accuracy} and " +
#     "#{approximate_value + @accuracy})"
#   end
#     
# end