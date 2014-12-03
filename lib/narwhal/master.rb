module Narwhal

  class Master
    SIGNALS = [ :INT, :QUIT, :TERM, :HUP, :USR1, :USR2 ]

    attr_reader :environment, :signal_queue

    def initialize(options)
      @environment = options[:environment]
      @signal_queue = []
    end

    def run!
      initialize_signal_handlers!

      loop do
        case signal_queue.shift
        when :INT
          Narwhal.log("signal=INT")
          break
        when :QUIT
          Narwhal.log("signal=QUIT")
          break
        when :TERM
          Narwhal.log("signal=TERM")
          break
        when :HUP
          Narwhal.log("signal=HUP")
        when :USR1
          Narwhal.log("signal=USR1")
        when :USR2
          Narwhal.log("signal=USR2")
        else
          Narwhal.log("running=true")
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
