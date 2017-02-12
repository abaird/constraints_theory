RSpec.describe Worker do
  context '.new' do
    it 'initializes correctly' do
      expect(subject.rate).to eq 1
    end

    it { is_expected.to have_empty_queues }
  end
  context '.pop' do
    it 'is nil when there is nothing in the queue' do
      expect(subject.pop).to eq nil
      subject.push('foo')
      subject.tick
      subject.pop
      expect(subject.pop).to eq nil
    end
  end
  context '1 tick worker' do
    it 'one tick finishes the work for one item' do
      subject.push('one')
      subject.tick
      expect(subject.input_length).to eq 0
      expect(subject.output_length).to eq 1
      expect(subject.pop).to eq 'one'
    end

    it 'one tick only finishes one item when two are queued' do
      subject.push('one', 'two')
      subject.tick
      expect(subject.input_length).to eq 1
      expect(subject.output_length).to eq 1
      expect(subject.pop).to eq 'one'
      expect(subject.input_queue).to eq 'two'
      expect(subject.pop).to eq nil
    end

    it 'ticks through multiple ticks' do
      completed_work = []
      subject.push('one', 'two', 'three')
      3.times { subject.tick }
      3.times { completed_work << subject.pop }
      expect(completed_work).to eq %w(one two three)
      expect(subject).to have_empty_queues
    end

    it 'continues to tick with no input' do
      subject.push('one')
      expect { 3.times { subject.tick } }.to_not raise_error
      expect(subject.output_length).to eq 1
    end
  end

  context 'two tick worker' do
    subject { Worker.new(rate: 2) }

    it 'two ticks finishes the work for one item' do
      subject.push('one')
      2.times { subject.tick }
      expect(subject.input_length).to eq 0
      expect(subject.output_length).to eq 1
      expect(subject.pop).to eq 'one'
    end

    it 'two ticks only finishes one item when two are queued' do
      subject.push('one', 'two')
      2.times { subject.tick }
      expect(subject.input_length).to eq 1
      expect(subject.output_length).to eq 1
      expect(subject.pop).to eq 'one'
      expect(subject.input_queue).to eq 'two'
    end

    it 'ticks through multiple ticks' do
      completed_work = []
      subject.push('one', 'two', 'three')
      6.times { subject.tick }
      3.times { completed_work << subject.pop }
      expect(completed_work).to eq %w(one two three)
      expect(subject).to have_empty_queues
    end

    it 'ticks through multiple cycles with a gap' do
      completed_work = []
      subject.push('one')
      6.times { subject.tick }
      subject.push('two', 'three')
      5.times { subject.tick }
      4.times { completed_work << subject.pop }
      expect(completed_work).to eq %w(one two three) + [nil]
      expect(subject).to have_empty_queues
    end

    it 'continues to tick with no input' do
      subject.push('one')
      expect { 6.times { subject.tick } }.to_not raise_error
      expect(subject.output_length).to eq 1
    end
  end

  context '.tick' do
    subject { Worker.new(rate: 2) }

    it 'raises no error when ticking without input' do
      subject.push('one')
      expect { 6.times { subject.tick } }.to_not raise_error
      expect(subject.output_length).to eq 1
    end

    it 'handles fractional completion cycles' do
      subject.push('one', 'two')
      subject.tick
      expect(subject.input_length).to eq 2
      expect(subject.output_length).to eq 0
      subject.tick
      expect(subject.input_length).to eq 1
      expect(subject.output_length).to eq 1
      subject.tick
      expect(subject.input_length).to eq 1
      expect(subject.output_length).to eq 1
      subject.tick
      expect(subject.input_length).to eq 0
      expect(subject.output_length).to eq 2
    end
  end
end
