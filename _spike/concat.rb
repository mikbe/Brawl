require 'benchmark'

x = [1,2,3]
puts x.object_id

x.concat [4,5] # same object
puts x.object_id

x += [6,7] # different object
puts x.object_id


Benchmark.bmbm do |bm|
  x = ("X"*100).split("")
  y = ("Y"*100).split("")
  times = 1000

  bm.report{times.times {x.concat y}}
  bm.report{times.times {x += y}} # substantially slower
  
end

=begin
  user     system      total        real
0.000000   0.000000   0.000000 (  0.001476)
2.950000   2.140000   5.090000 (  6.061063)
=end