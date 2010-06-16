
module RDF::Raptor::CLI::Writer

      def flush_pipe # hack to fix blocking problem
        begin
          chunk_size = @options[:chunk_size] || 4096 # bytes
          @output.write(@rapper.read_nonblock(chunk_size))
        rescue EOFError, Errno::EAGAIN
          # hack OK
        end
      end

      def write_triple_with_flush(s,p,o)
        write_triple_without_flush(s,p,o)
        flush_pipe
      end

      alias_method_chain :write_triple,:flush

end