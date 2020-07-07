# enccoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/logs/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-logs"
  spec.version       = Rack::Logs::VERSION
  spec.authors       = ["Jon Rowe"]
  spec.email         = ["hello@jonrowe.co.uk"]
  spec.description   = %q{Simple rack based log viewer}
  spec.summary       = %q{Simple rack based log viewer}
  spec.homepage      = "https://github.com/JonRowe/rack-logs"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '> 1.9'

  if RUBY_VERSION.to_f < 2.3
    spec.add_runtime_dependency "rack", "~> 1.6.12"
  else
    spec.add_runtime_dependency "rack", "~> 2.2.3"
  end

  if RUBY_VERSION.to_f < 1.9 || RUBY_VERSION == '1.9.2'
    spec.add_development_dependency "rake", "~> 10.0.0"
  elsif RUBY_VERSION.to_f < 2
    spec.add_development_dependency "rake", "~> 11.0.0"
  elsif RUBY_VERSION.to_f < 2.3
    spec.add_development_dependency "rake", "~> 12.3.2"
  else
    spec.add_development_dependency "rake", "~> 13.0.0"
  end

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec",   "~> 3.9.0"
end
