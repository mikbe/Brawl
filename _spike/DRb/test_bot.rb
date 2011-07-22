puts "running test_bot"
code.loop do |bot|
  puts "bot code loop"
  value = bot.move rand(3)+1
  puts "value: #{value}"
end
