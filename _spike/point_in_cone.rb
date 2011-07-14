
def point_in_cone(args)
  radius, angle, direction, bot, target = args[:radius], args[:angle], args[:direction], args[:bot], args[:target]
  x1, y1, x2, y2 = bot[:x], bot[:y], target[:x], target[:y]
  distance = Math.sqrt((x1 - target[:x])**2 + (y1 - y2)**2)
  return false if distance > radius
  
  azimuth = Math.atan2(x2 - x1, y2 - y1)
  
  min = (Math::PI / 180) * ((direction - (angle / 2)) % 360)
  max = (Math::PI / 180) * ((direction + (angle / 2)) % 360)

  if min > max
    azimuth >= min || azimuth <= max
  else
    azimuth >= min && azimuth <= max
  end
end

puts point_in_cone radius: 10, angle: 90, direction: 0, bot: {x: 0, y: 0}, target: {x: 10, y: 0}