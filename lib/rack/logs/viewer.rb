module Rack
  module Logs
    class Viewer

      def initialize config
        @config = config
      end
      attr_reader :config

      def call env
        [200, headers, joined_logs]
      end

    private

      def headers
        {
          'Content-Type' => 'text/plain'
        }
      end

      class JoinedFiles
        def initialize filenames
          @filenames = filenames
        end

        def each &block
          @filenames.each do |filename|
            block.call "## #{filename}\n\n"
            ::File.open(filename) do |file|
              file.each(&block)
            end
          end
        end
      end

      def joined_logs
        JoinedFiles.new files
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
