# Rack::Logs

Simple rack mountable log viewer.

## Installation

Add this line to your application's Gemfile:

    gem 'rack-logs'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-logs

## Usage

Mount as `rack` middleware to expose your logs.

** `rack-logs` exposes potentially sensitive information that may be contained
in your logs, please secure your stack against unauthorised access**

```Ruby
use Rack::Logs do |config|
  # controls the pattern used to find logs, defaults to *.log
  config.pattern = '*.log'

  # controls the directory searched for logs, defaults to `./log`
  config.log_dir = File.expand_path('../log',__FILE__)
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
