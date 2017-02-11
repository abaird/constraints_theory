class Worker
  attr_accessor :queue
  def initialize(rate:1)
    @rate = rate
    @queue = 0
  end

  def tick
  end

  def push
  end

  def pop
  end
end
