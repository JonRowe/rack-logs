require "rack/logs/version"

if RUBY_VERSION.to_f < 2
  require 'rack/logs/backport'
end

module Rack
  module Logs
    module_function

    autoload 'Viewer', 'rack/logs/viewer'
    autoload 'Config', 'rack/logs/config'

    def configure
      Rack::Logs::Viewer.new Config.new.tap { |c| yield c }
    end

    def call env
      configure {}.call env
    end

  end
end
