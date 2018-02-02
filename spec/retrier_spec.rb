# frozen_string_literal: true

describe Retrier do
  class RetriableError < StandardError; end
  class NonRetriableError < StandardError; end

  subject { described_class.new(RetriableError, waiting_time: 1, attempts: attempts) }
  let(:attempts) { 3 }

  before { allow(described_class).to receive(:sleep) }

  describe '#execute' do
    it 'returns a result when there is no error' do
      expect(subject.execute { 'result' }).to eq('result')
    end

    it 'retries and returns a result when there is a temporary error' do
      block_executions = 0

      expect(
        subject.execute do
          block_executions += 1

          # raise an error at the first attempt
          # return a result at the second one
          block_executions.odd? ? raise(RetriableError) : 'result'
        end
      ).to eq('result')

      expect(block_executions).to eq(2)
    end

    it 'retries and raises when there is a persistent error' do
      block_executions = 0

      expect do
        subject.execute do
          block_executions += 1

          raise(RetriableError, 'There is something wrong here')
        end
      end.to raise_error(RetriableError, 'There is something wrong here')

      expect(block_executions).to eq(attempts)
    end

    it 'raises an error when error is not the one to retry' do
      expect do
        subject.execute do
          raise NonRetriableError
        end
      end.to raise_error(NonRetriableError)
    end
  end
end
