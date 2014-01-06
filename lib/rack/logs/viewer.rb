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
              tail(file, @lines).each do |line|
                block.call line
              end
            end
          end
        end

      private

        def tail file, n
          index = 1
          lines = 0
          buffer = ""

          if file.size > 1024
            begin
              file.seek(index * (1024 * -1), IO::SEEK_END)
              chunk = file.read(1024)
              lines += chunk.count("\n")
              buffer.prepend chunk
              index += 1
            end while lines < n && file.pos >= 0
          else
            buffer = file.read
          end

          buffer.lines.pop n
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
