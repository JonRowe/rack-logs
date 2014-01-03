module Rack
  module Logs
    class Config

      def initialize
        @pattern = '*.log'
        @log_dir = './log'
        @lines   = 200
      end

      attr_accessor :pattern, :log_dir, :lines

    end
  end
end
