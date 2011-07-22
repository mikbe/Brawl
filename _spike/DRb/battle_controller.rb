#require 'uuidtools'
$DEBUG = true

require_relative 'arena'
require_relative 'server'
require_relative 'bot_runner'

class RunIt
  def run(server, code)
    bot = BotRunner.new(code)
    fork do
      Signal.trap("HUP") { puts "Die! #{server}"; bot.stop; exit}
      bot.connect(server)
      bot.run
      while true
        sleep(0.25)
      end
    end
  end
end

arena = Arena.new
code = File.read("test_bot.rb")
puts "test code: #{code}"
client_id1 = "client1"
arena_proxy1 = ArenaProxy.new(arena, client_id1)
arena.add_bot(client_id1)
bot1_server = Server.new
bot1_server.start(object: arena_proxy1)
r1 = RunIt.new
pid1 = r1.run(bot1_server.uri, code)

client_id2 = "client2"
arena_proxy2 = ArenaProxy.new(arena, client_id2)
arena.add_bot(client_id2)
bot2_server = Server.new
bot2_server.start(object: arena_proxy2)
r2 = RunIt.new
pid2 = r2.run(bot2_server.uri, code)

timeout = Time.now + 3
while Time.now < timeout
  sleep(0.05)
end
bot1_server.stop
Process.kill("HUP", pid1)
sleep(2.0)
bot2_server.stop
Process.kill("HUP", pid2)
Process.wait




