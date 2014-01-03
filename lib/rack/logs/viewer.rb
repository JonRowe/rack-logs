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
        include Enumerable

        def initialize filenames, lines
          @filenames = filenames
          @lines = lines
        end

        def each &block
          @filenames.each do |filename|
            block.call "## #{filename}\n\n"
            ::File.open(filename) do |file|
              total = 0
              file.each_line { total += 1 }
              progress = 0
              file.rewind
              file.each_line do |line|
                if progress > (total - @lines)
                  block.call line
                end
                progress += 1
              end
            end
          end
        end
      end

      def joined_logs
        JoinedFiles.new files, @config.lines
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
