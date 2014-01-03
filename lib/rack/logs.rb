require "rack/logs/version"

module Rack
  module Logs
    module_function

    def configure
      Rack::Logs::Viewer.new Config.new.tap { |c| yield c }
    end

    def call env
      [200, {}, []]
    end

  end
end
