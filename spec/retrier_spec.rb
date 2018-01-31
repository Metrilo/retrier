# frozen_string_literal: true

module RetrierTest
  class RetriableError < StandardError; end
  class NonRetriableError < StandardError; end
end

describe Retrier do
  subject { described_class.new(RetrierTest::RetriableError, waiting_time: 1, attempts: attempts) }
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
          block_executions.odd? ? raise(RetrierTest::RetriableError) : 'result'
        end
      ).to eq('result')

      expect(block_executions).to eq(2)
    end

    it 'retries and raises when there is a persistent error' do
      block_executions = 0

      expect do
        subject.execute do
          block_executions += 1

          raise(RetrierTest::RetriableError, 'There is something wrong here')
        end
      end.to raise_error(RetrierTest::RetriableError, 'There is something wrong here')

      expect(block_executions).to eq(attempts)
    end

    it 'raises an error when error is not the one to retry' do
      expect do
        subject.execute do
          raise RetrierTest::NonRetriableError
        end
      end.to raise_error(RetrierTest::NonRetriableError)
    end
  end
end
