x = [{a: "a"}, {b: "b"}, {c: "c"}]

class Hash
  def each_hash
    self.each_pair do |key, value|
      yield key => value
    end
  end
end

def foo(hashes)
  hashes.each_hash do |hash|
    puts hash.inspect
  end
end

foo(a: "a", b: "b", c: "c")
