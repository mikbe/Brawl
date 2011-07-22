class MsgForward
  
  def initialize
    @mutex    = Mutex.new
    @msg      = nil
    @params   = nil
    @response = nil
  end

  def send(msg, *params)
    @msg    = msg
    @params = params
    until @response {sleep(0.01)}
  end
  
end