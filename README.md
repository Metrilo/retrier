`Retrier` is a small Ruby class that helps you try to execute a block of code more than once.
It catches a specific exception, waits for a certain amount of time and tries the code again until the retry count is exhausted.

You just pass: `ErrorClass`, `waiting_time` (seconds), `attempts`:
```ruby
retrier = Retrier.new(Mailgun::Error, waiting_time: 5, attempts: 3)

retrier.execute do
  # arbitrary Ruby code
end
```

Defaults:
- waiting_time: 3 seconds
- attempts: 3 times
