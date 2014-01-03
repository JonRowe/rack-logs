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

  spec.add_runtime_dependency "rack", "~> 1.5.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec",   "~> 3.0.0.beta1"
end
