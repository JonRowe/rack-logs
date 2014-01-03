require "rack/logs/version"

module Rack
  module Logs

    def self.call env
      [200, {}, []]
    end

  end
end
