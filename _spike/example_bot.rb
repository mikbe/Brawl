class BasicBot
  
end

# this isn't meant to be a good bot, just to show the features of bots
code.loop do |bot|

  scan_results = bot.scan direction: 0, angle: 45
  
  unless (enemies = scan_results.contacts.select {|contact| contact.type == :enemy}).empty?

    # you should get the closest probably, not just the first in the array
    enemy = enemies.first
    
    if enemy.distance <= bot.weapon.range do
      bot.fire direction: enemy.direction
    else
      bot.turn direction: enemy.direction
      bot.move
    end
    
  else
    
    # No enemy spotted so move around randomly
    # mostly go straight but turn randomly sometimes
    unless rand(100) > 70 and scan_result.any? {|contact| contact.direction == :front && contact.distance == 1}
      bot.move direction: :forward
    else
      [:right, :left].sample do |direction|
        # if the enemy gets right behind you, you could go into an endless loop
        bot.turn direction until (bot.scan direction: 0, angle: 0).contacts.empty
        bot.move
      end
    end
    
  end

end
