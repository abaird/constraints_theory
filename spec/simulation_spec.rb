require 'spec_helper'

describe Simulation do
  it 'has 10 lines of output' do
    output = mock_io('') { Simulation.new(length: 10).run }
    puts output
    expect(output.split("\n").count).to eq(10)
  end
end
