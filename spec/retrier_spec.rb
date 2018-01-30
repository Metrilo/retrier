# frozen_string_literal: true

class Error < StandardError; end

describe Retrier do
  subject { described_class.new(Error, waiting_time: 1, attempts: attempts) }
  let(:attempts) { 3 }

  before { allow(described_class).to receive(:sleep) }

  describe '#execute' do
    it 'returns a result if there is no error' do
      expect(subject.execute { 'result' }).to eq('result')
    end

    it 'retries and returns a result if there is a temporary error' do
      block_executions = 0

      expect(
        subject.execute do
          block_executions += 1

          # raise an error at the first attempt
          # return a result at the second one
          block_executions.odd? ? raise(Error) : 'result'
        end
      ).to eq('result')

      expect(block_executions).to eq(2)
    end

    it 'retries and raises if there is a persistent error' do
      block_executions = 0

      expect do
        subject.execute do
          block_executions += 1

          raise(Error, 'There is something wrong here')
        end
      end.to raise_error(Error, 'There is something wrong here')

      expect(block_executions).to eq(attempts)
    end
  end
end
