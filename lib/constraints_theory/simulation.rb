class Simulation
  def initialize(length: 100)
    @simulation_length = length
  end

  def run
    n = 0
    loop do
      puts n.to_s
      n += 1
      return if n == @simulation_length
    end
  end
end
