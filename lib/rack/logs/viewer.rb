module Rack
  module Logs
    class Viewer

      def initialize config
        @config = config
      end
      attr_reader :config

      def call env
        [200, headers, [joined_logs]]
      end

    private

      def headers
        {
          'Content-Type' => 'text/plain'
        }
      end

      def joined_logs
        logs.inject("") do |string, (filename, contents)|
          string + "## " + filename + "\n\n" + contents
        end
      end

      def logs
        files.inject({}) do |hash, filename|
          hash[filename] = ::File.read(filename)
          hash
        end
      end

      def files
        Dir[@config.log_dir+'/'+@config.pattern]
      end

    end
  end
end
