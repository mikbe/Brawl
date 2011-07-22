require 'drb'
require_relative 'bot'

class BotRunner

  attr_reader :proxy
  
  def initialize(code)
    @mutex = Mutex.new
    make_run(code)
  end
  
  def connect(server)
    @server = server
    @run = true
    puts "connecting: #{@server}"
    DRb.start_service
    @proxy = DRbObject.new(nil, server)
  end
  
  def stop
    @run = false
    DRb.stop_service
  end


  # def run
  #   Thread.start {
  #     msg = []
  #     response = []
  #     Thread.start {
  #       $SAFE = 1
  #       code = Brawl::Bot.new(msg, response)
  #       while @run
  #         sleep(rand(0))
  #         code.loop do |bot|
  #           puts "bot code loop"
  #           value = @proxy.move([rand(3)])
  #           puts "value: #{value}"
  #         end
  #       end
  #     }
  #   }
  # end


  # def run
  #   Thread.start {
  #     msg = []
  #     response = []
  #     Thread.start {
  #       $SAFE = 3
  #       code = Brawl::Bot.new(msg, response)
  #       while @run
  #         sleep(rand(0))
  #         code.loop do |bot|
  #           puts "bot code loop"
  #           value = bot.move rand(3)+1
  #           puts "value: #{value}"
  #         end
  #       end
  #     }
  #     while @run
  #       sleep(0.05) while msg.empty?
  #       puts "got a message"
  #       sleep(0.25)
  #       proxy_response = @proxy.send msg.first, msg[1..-1]
  #       msg.clear
  #       response << proxy_response
  #     end
  #   }
  # end

  private 
  
  def make_run(code)
    method = 
    %Q{
      def run
        Thread.start {
          msg = []
          response = []
          Thread.start {
            $SAFE = 3
            code = Brawl::Bot.new(msg, response)
            while @run
              puts "looping"
              sleep(rand(0))
              #{code}
            end
          }
          while @run
            sleep(0.05) while msg.empty?
            puts "got a message"
            sleep(0.25)
            proxy_response = @proxy.send msg.first, msg[1..-1]
            msg.clear
            response << proxy_response
          end
        }
      end
    }
    instance_eval(method)
  end
  
  def send(msg)
    @msg = msg
  end
  
end
