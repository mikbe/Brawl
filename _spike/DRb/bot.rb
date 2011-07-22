module Brawl
class Bot
  
  def initialize(msg, response)
    @msg      = msg
    @response = response
  end
  
  def move(amount)
    @msg.clear
    @msg.concat [:move, amount]
    sleep(0.05) while @response.empty?
    return_value = Marshal.load(Marshal.dump(@response))
    @response.clear
    return_value
  end
  
  def loop
    yield self
  end
  
end
end