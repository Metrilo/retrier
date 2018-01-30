`Retrier` is a small ruby class that helps you try to execute a block of code more than once.
It catches a specific exception, waits certain amount of time and tries the code again until the retry count is exhausted.

You just pass: `ErrorClass`, `waiting_time` (seconds), `attempts`:
```ruby
retrier = Retrier.new(Mailgun::Error, waiting_time: 5, attempts: 3)

retrier.execute do
  # some request to Mailgun or other third-party API
end
```

Defaults:
- waiting_time: 3 seconds
- attempts: 3 times
