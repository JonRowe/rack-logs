require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'

  desc "Run unit tests"
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.ruby_opts = %w[-w]
    t.pattern = 'spec/unit/**/*_spec.rb'
  end

  desc "Run integration tests"
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.ruby_opts = %w[-w]
    t.pattern = 'spec/integration/**/*_spec.rb'
  end

  desc "Run both spec suites in order by default"
  task default: %w[unit integration]

rescue LoadError
  puts "RSpec Unavailable"
end
