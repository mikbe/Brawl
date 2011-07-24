require 'benchmark'

Benchmark.bmbm do |bm|
  bm.report {x = []; 100000.times {x << "A"}}
  bm.report {x = []; 10000.times {x.concat ["A"]}}
  bm.report {x = []; 100000.times {x.push "A"}}
end