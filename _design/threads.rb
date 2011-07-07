Thread.abort_on_exception = true

class Time
  def self.time
    Time.now.strftime("%H:%M:%S.%L")
  end
end

module Kernel
  def tputs(message)
    puts "#{Time.time}   #{message}"
  end
end

class Resource
  @mutex = Mutex.new

  def self.do(count, time)
    tputs "do: #{count}"
    count.times do |index|
      self.use(count, time, index)
    end
  end

  def self.use(count, time, index)
    @mutex.synchronize do
      timeout = Time.now + time
      sleep(0.01) while Time.now < timeout
      tputs "#{index} for count: #{count}"
    end
    # This sleep seems to be crucial. The mutex is released but if I
    # don't have a sleep here the next thing waiting for the mutex 
    # doesn't seem to get the resource.
    sleep(0.001)
  end

end

class Worker

  def initialize(&block)
    @block = block
  end

  def start
    @stop_working = nil
    tputs "Starting: #{@block}"
    Thread.new do
      until @stop_working
        @block.call
      end
    end
  end

  def stop
    @stop_working = false
  end
end

#slow = Worker.new {Resource.do_something(5,0.2)}
#fast = Worker.new {sleep(0.5);Resource.do_something(1,0.1)}
slow = Worker.new {Resource.do(3,0.25)}
fast = Worker.new {sleep(1.5); Resource.do(1,0.1)}
slow.start
fast.start
stop = Time.now + 5
sleep(0.01) while stop > Time.now

slow.stop
fast.stop

