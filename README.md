# Brawl

A dangerous robotic programming game that will kill you in your sleep.

Write robotic assassins using Ruby and watch them as they do your evil bidding.

## Status
**Alpha Development**

Brawl is a work in progress but currently supports running bots on your local machine with limited security.

## Features
The framework is designed from the ground up to be extendable. Want to add some new functionality to robots like dropping land mines, semi-intelligent turrets, or heat seeking missiles? Just write a new part and load it into your bot.

## Security
Brawl was also designed to be secure (when the DRb methodology is implemented). In the secure version (in prototype stage now) bot code runs in a $SAFE = 4 process fork and communicates via a wrapper that uses DRb to talk to a proxy object on the server. 

Whew, that was a mouth full but what it basically means is you can feel reasonably safe running other people's code on your machine. They won't be able to erase your hard drive, probably, much less hack your bots or the game engine to cheat.

Legal Notice: This is not a guarantee of fitness or anything else. If you use other people's code without understanding what it does expect your entire system to melt.

## Example bot programs

This is a really dumb robot that just scans for enemies and shoots at them. If it can't find an enemy it will move around till it does. How would you improve it?  

    code do |bot|
      @dir ||= 0
      targets = bot.scan direction: @dir, angle: 90
      @dir += 45
      @dir %= 360
      if targets.each do |target|
          unless target[:class] == Brawl::Wall
            results = shoot(target[:bearing])
          end
        end
      else
        if rand(0) > 0.5
          bot.turn [:left,:right,:around].sample
        end
        bot.move rand(3) + 1
      end
    end
  