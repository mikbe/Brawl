
def foo(stop_at)
  (0...100).each do |index|
    break index if index == stop_at
  end
  
end


puts foo(20)