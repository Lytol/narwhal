module Narwhal

  class Worker
    attr_accessor :pid
    attr_reader :index

    SIGNALS = [ :QUIT, :INT, :TERM ]

    def initialize(index)
      @index = index
      @signal_queue = []
    end

    def run!
      initialize_signal_handlers!

      Narwhal.title = "worker[#{index}] ready"

      loop do
        case @signal_queue.shift
        when :QUIT # Terminate abruptly
          Narwhal.log("worker[#{index}] signal=QUIT")
          exit(0)
        when :TERM, :INT # Terminate gracefully
          Narwhal.log("worker[#{index}] signal=TERM")
          exit(0)
        else
          # Wait for next message from master, process when ready
          Narwhal.log("worker[#{index}] running=true")
          sleep(1)
        end
      end
    end

    private

      def initialize_signal_handlers!
        SIGNALS.each do |sig|
          trap(sig) { @signal_queue << sig }
        end
      end

  end
end
