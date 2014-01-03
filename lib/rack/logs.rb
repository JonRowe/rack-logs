require "rack/logs/version"

module Rack
  module Logs
    module_function

    autoload 'Config', 'rack/logs/config'

    def configure
      Rack::Logs::Viewer.new Config.new.tap { |c| yield c }
    end

    def call env
      configure {}.call env
    end

  end
end
