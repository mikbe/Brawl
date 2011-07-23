require "bigdecimal"
require "bigdecimal/math"

include BigMath

def to_radian(angle)
  big_angle = BigDecimal(angle.to_s)
  big_angle * (PI(100) / 180.0)
end

def to_degree(angle)
  big_angle = BigDecimal(angle.to_s)
  big_angle * (180.0 / PI(100))
end


angle = -320
puts "angle: #{angle}"
radians = to_radian angle
sin = Math.sin(radians).abs
puts "rad:   #{radians}"
puts "sin:   #{sin}"
asin = Math.asin(sin)
puts "asin:  #{asin}"
wrap_angle =  to_degree asin
puts "wrap:  #{wrap_angle.round}"
# radian90 = to radian: 90
# puts "90 degrees to radian:  #{radian90}"
# puts "90 radians to degrees: #{to degree: radian90}"