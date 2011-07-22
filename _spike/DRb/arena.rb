class Arena
  attr_accessor :counter
  def initialize
    @counter = ""
    @bots = {}
  end
  
  def add_bot(client_id)
    @bots[client_id] = {position: 0}
  end
  
  def move(value, client_id)
    puts "move called: #{value.inspect}; #{client_id}"
    @bots[client_id][:position] += value.first
  end
  
end

class ArenaProxy
  
  attr_accessor :client_id
  
  def initialize(arena, client_id=nil)
    @arena      = arena
    @client_id  = client_id
  end
  
  def move(amount)
    @arena.move(amount, client_id)
  end
  
end
