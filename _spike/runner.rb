class Arena
  def initialize
    @secret = "super secret"
  end
  
  def protected
    puts "protected called"
  end
  
end

class ArenaProxy
  def initialize(arena)
    @arena = arena
  end
end

class BasicBot
  def initialize(arena_proxy)
    @arena_proxy = arena_proxy
  end
end

class Code
  def self.loop
    arena = Arena.new
    ap    = ArenaProxy.new(arena)
    bot   = BasicBot.new(ap)
    yield bot
  end
end

module Runner
  secret = ""
  Thread.start {
    $SAFE = 4
      Code.loop do |bot|
        ap = bot.instance_variable_get(:@arena_proxy)
        a  = ap.instance_variable_get(:@arena)
        secret = a.instance_variable_get(:@secret)
      end
  }.join
  puts secret
end