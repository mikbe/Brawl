x = [1,2,3,4,5,6].collect do |num|
  next false if num % 2 == 0
  true
end

puts x.inspect

