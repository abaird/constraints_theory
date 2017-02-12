class Simulation
  def initialize(length: 100)
    @simulation_length = length
    @workers = []
    @ticks = 0
    @input = %w(1 2 3 4 5 6 7 8 9 10)
  end

  def run
    @workers[0].push(*@input)
    loop do
      @workers[0].tick
      print_status
      @workers[0].pop
      @ticks += 1
      return if @ticks == @simulation_length
    end
  end

  def input_stack(*input)
    @input = input
  end

  def print_status
    puts "#{@ticks} ticks: input length: " \
         "#{@workers[0].input_length}, " \
         "output value: #{@workers[0].output_queue}"
  end

  def register_worker(rate)
    @workers << Worker.new(rate: rate)
    self
  end
end
