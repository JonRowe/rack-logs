module Rack
  module Logs
    class Viewer

      def initialize config
        @config = config
      end
      attr_reader :config

      def call env
        contents = joined_logs(env.fetch('PATH_INFO','/'))
        if contents.empty?
          [404, headers, ['No Such File']]
        else
          [200, headers, contents]
        end
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

        def empty?
          @filenames.empty?
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

      def joined_logs path
        JoinedFiles.new files(path), @config.lines
      end

      def logs
        files.inject({}) do |hash, filename|
          hash[filename] = ::File.read(filename)
          hash
        end
      end

      def files path
        Dir[@config.log_dir+'/'+@config.pattern].select do |filename|
          filename =~ Regexp.new( @config.log_dir + path )
        end
      end

    end
  end
end
