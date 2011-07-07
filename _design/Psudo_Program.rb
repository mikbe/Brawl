# Brainstorming what a bot program might look like so I can figure out how to deal with it

# I've removed the idea of throttling. Throttling changes the model from event based
# to event/queue based so then there's no point in multi-threading in the first place.

# Bots are divided into classes by points and attachments (mixin modules that add more functionality)
# A basic bot might be allowed 10 points to allocate. The more points the better the system of course.
# 

# This defines your robot's caracteristics
Bot.build
  {
    # required
    scanner:      2,
    motor:        2,
    laser:        2,
    shield:       4,
    # optional
    name:         "Full function bot",
    author:       "Mike Bethany",
    description:  "A simple but full featured robot to show all the capabilities",
    revision:     '0.0.1',
  }
# Should there be some kind of GUID handed out by a central command to identify bots?

# These are things that can happen and should be responded to
event :enemy_found
event :enemy_lost

# This loop looks for an enemy and tries to track it
# (loop creates a thread)
@contact = nil
Scanner.loop do

  # try to keep the scanner locked on the enemy
  if @contact and @contact.is_enemy?
    direction, sweep, range = contact.direction - 5, 10, @contact.range + 2
  else
    # lazy scanning 
    # It's very slow since it's scanning the maximum range in a full circle
    direction, sweep, range = 0, 360, :max
  end
  @contact = scan direction: direction, sweep: sweep, range: range
end

# Another scanner thread that is a lot faster and just looks for walls
Scanner.loop do
  if check_for_walls(:front)
    [:left, :right].each do |direction|
      @walls[direction] = 
    end
  fire_event(:wall)
end

def check_for_walls(direction)
  # This is a really fast scan because it's scanning the minimum distance at only 1 degree
  !Scanner.scan direction: direction, sweep: 1, range: Motor.speed
end

# Another low priority thread that moves the bot around randomly
Motor.loop do
  if Motor.dead_end
    reverse
    Motor.dead_end = false
  else
    # mostly go straight but turn randomly sometimes
    unless rand(100) > 70 and check_for_wall(:front)
      forward unless Motor.direction == :forward
    else
      # turning takes time and is blocking
      Motor.dead_end = random_turn
    end
  end
end

def random_turn
  directions = [:left,:right]
  while pick = directions.delete(rand(directions.length)) 
    unless check_for_wall(pick)
      turn pick
      break
    end
  end
  !directions.is_empty?
end


# This does not create a thread/loop but instead dynamcially creates a method using the given block
# You can call it whatever you want as long as you don't pick something that's already taken.
# If you try to overwrite methods that are important to the bot like forward or reverse they 
# won't be used since this would break the system's ability to interact with your bot.
Laser.engage do |contact|
  # lazy aiming (a better approach might be to remember the last few contacts and try to extrapolate position)

  # Aim sends the command to move the turrent but it's a non-blocking call
  aim contact.direction

  # Since aim is a non-blocking call you might not actually be pointed at the enemy yet
  fire if contact.distance <= Laser.range and Scanner.scan direction: contact.direction, sweep: 3, range: contact.distance, priority: 5
end

# Again this method is created dynamically using the given block
Motor.pursue do |contact|

end



