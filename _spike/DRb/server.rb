require 'drb'

class Server
  
  def start(params)
    port    = params[:port] ? "druby://:#{params[:port]}" : nil
    object  = params[:object]
    @service = DRb.start_service(port, object)
  end
  
  def stop
    @service.stop_service
  end
  
  def uri
    @service.uri
  end
  
end

# server = Server.new
# server.start(object: ArenaProxy.new)
# puts server
# puts server.uri
# DRb.thread.join



