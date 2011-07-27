
def to_radians(angle)
  angle * (Math::PI / 180)
end

def to_degrees(angle)
  angle * (180.0 / Math::PI)
end

# x1, y1 = 5,5
# x2, y2 = 6,6
# x2, y2 = 5,5
# x1, y1 = 6,6

x1, y1 = 5,5
x2, y2 = 5,6
puts "0 : #{to_degrees(Math.atan2(x2 - x1, y2 - y1)) % 360}"

x2, y2 = 6,6
puts "45 : #{to_degrees(Math.atan2(x2 - x1, y2 - y1)) % 360}"

x2, y2 = 6,5
puts "90 : #{to_degrees(Math.atan2(x2 - x1, y2 - y1)) % 360}"

x2, y2 = 6,4
puts "135 : #{to_degrees(Math.atan2(x2 - x1, y2 - y1)) % 360}"

x2, y2 = 5,4
puts "180 : #{to_degrees(Math.atan2(x2 - x1, y2 - y1)) % 360}"

x2, y2 = 4,4
puts "225 : #{to_degrees(Math.atan2(x2 - x1, y2 - y1)) % 360}"

x2, y2 = 4,5
puts "270 : #{to_degrees(Math.atan2(x2 - x1, y2 - y1)) % 360}"

x2, y2 = 4,6
puts "315 : #{to_degrees(Math.atan2(x2 - x1, y2 - y1)) % 360}"

