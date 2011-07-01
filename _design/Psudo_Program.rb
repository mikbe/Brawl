# Brainstorming what a bot program might look like so I can figure out how to deal with it

# Bots are divided into classes by points and attachments (mixin modules that add more functionality)
# A basic bot might be allowed 10 points to allocate. The more points the better the system of course.

# This defines your robot's caracteristics
Bot.build
  {
    # required
    scanner:      2,
    motor:        2,
    weapon:       2,
    shield:       4,
    # optional
    name:        "Full function bot",
    author:      "Mike Bethany",
    description: "A simple but full featured robot to show all the capabilities",
    revision:     '0.0.1',
  }

# These are things that can happen and should be responded to
event :enemy_found
event :enemy_lost

# Creates a thread for the scanner and starts it running in a loop
# Throttling is done by limiting how often the loop can run.
# How am I going to deal with variables like "contact" below?
# An object should have come kind of register that shows it has
# run a command this loop and if you try to run the particular 
# command more than once per loop it just returns nil, this will
# keep people from running their own loop inside the thread to cheat.
# 
Scanner.loop do
  priority 1
  # try to keep the scanner locked on the enemy
  if contact and contact.is_enemy?
    scan direction: contact.direction - 5, sweep: 10
  else
    # lazy scanning - it's also very slow since it's scanning the maximum range and in a full circle
    range :max
    scan direction: 0, sweep: 360
  end
end

# Another low priority thread that moves the bot around randomly
Motor.loop do
  priority 1
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

def check_for_walls(direction)
  # This is a really fast scan because it's scanning the minium distance at only 1 degree
  # instead of not'ing the return you could use the return value to see if it's an enemy and shoot it
  !Scanner.scan priority: 10, direction: direction, sweep: 1, range: Motor.speed
end

# This does not create a thread/loop but instead dynamcially creates a method using the given block
# You can call it whatever you want as long as you don't pick something that's already taken.
# If you try to overwrite methods that are important to the bot like forward or reverse they 
# won't be used since this would break the system ability to interact with your bot.
Weapon.engage do |contact|
  # lazy aiming (a better approach might be to remember the last few contacts and try to extrapolate position)

  # Aim sends the command to move the turrent but it's a non-blocking call
  aim contact.direction

  # Since aim is a non-blocking call you might not actually be pointed at the enemy yet
  # Note how the scan has a higher priority than normal scanning but a lower one than scanning for walls.
  # Firing the weapon is more important than normal scanning but not running into walls is even more important.
  fire if contact.distance <= Weapon.range and Scanner.scan priority: 9, direction: contact.direction, sweep: 3, range: contact.distance
end

# Again this method is created dynamically using the given block
Motor.pursue do |contact|

end



