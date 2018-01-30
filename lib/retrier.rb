# frozen_string_literal: true

class Retrier
  VERSION = '0.0.1'

  def initialize(error_class, waiting_time: 3, attempts: 3)
    @error_class = error_class
    @waiting_time = waiting_time
    @attempts = attempts
  end

  def execute
    request_attempts = @attempts

    begin
      yield
    rescue @error_class => exception
      request_attempts -= 1

      unless request_attempts.zero?
        sleep @waiting_time
        retry
      end

      raise exception
    end
  end
end
