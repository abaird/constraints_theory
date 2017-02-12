require 'spec_helper'

describe Simulation do
  it 'has 20 lines of output' do
    output = mock_io('') do
      Simulation.new(length: 20).register_worker(2).run
    end
    puts output
    expect(output.split("\n").count).to eq(20)
  end
end
