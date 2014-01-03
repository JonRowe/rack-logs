module Rack
  module Logs
    class Config

      def initialize
        @pattern = '*.log'
        @log_dir = './log'
      end

      attr_accessor :pattern, :log_dir

    end
  end
end
