class Worker
  attr_reader :rate, :ticks
  def initialize(rate:1)
    @rate = rate # in ticks
    @input_queue = []
    @output_queue = []
    @ticks = 0
  end

  def tick
    return if input_length == 0
    increment_ticks
    return unless ticks == rate
    @output_queue << @input_queue.delete_at(0)
    @ticks = 0
  end

  def push(*items)
    items.each do |item|
      @input_queue << item
    end
  end

  def pop
    @output_queue.delete_at(0)
  end

  def input_queue
    @input_queue.first
  end

  def input_length
    @input_queue.length
  end

  def output_queue
    @output_queue.first
  end

  def output_length
    @output_queue.length
  end

  def reset!
    @input_queue = []
    @output_queue = []
  end

  private

  def increment_ticks
    @ticks += 1
  end
end
