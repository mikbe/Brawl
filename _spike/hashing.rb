x = [:a, :b, :c, :d, :e]

y = x.each_with_object({}) do |key, hash|
  hash[key] = key.to_s.ord
end

puts y