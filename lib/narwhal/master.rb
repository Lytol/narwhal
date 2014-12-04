module Narwhal

  class Master
    SIGNALS = [ :INT, :QUIT, :TERM, :HUP, :USR1, :USR2 ]

    attr_reader :environment, :worker_count, :pid

    def initialize(options)
      @environment = options[:environment]
      @worker_count = options[:worker_count]
      @pid = $$

      @signal_queue = []
      @workers = {}
    end

    def run!
      Narwhal.log("master started=true environment=#{environment} workers=#{worker_count} pid=#{pid}")

      initialize_signal_handlers!
      spawn_workers!

      Narwhal.title = "master ready"

      loop do
        case @signal_queue.shift
        when :INT, :TERM # Terminate gracefully
          Narwhal.log("master signal=INT")
          kill_all_workers!(:TERM)
          break
        when :QUIT # Terminate abruptly
          Narwhal.log("master signal=QUIT")
          kill_all_workers!(:QUIT)
          break
        when :HUP # TODO
          Narwhal.log("master signal=HUP")
        when :USR1 # TODO
          Narwhal.log("master signal=USR1")
        when :USR2 # TODO
          Narwhal.log("master signal=USR2")
        else
          # TODO: Wait for next message, pass along to available worker
          Narwhal.log("master timeout=true")
          sleep(1)
        end
      end

      Narwhal.log("master stopped=true")
    end

    private

      def initialize_signal_handlers!
        SIGNALS.each do |sig|
          trap(sig) { @signal_queue << sig }
        end
      end

      def spawn_workers!
        (1..worker_count).each do |n|
          next if @workers[n]

          worker = Worker.new(n)

          if pid = fork
            worker.pid = pid
            @workers[n] = worker
          else
            reset_for_worker!
            worker.pid = $$
            worker.run!
          end
        end
      end

      def reset_for_worker!
        SIGNALS.each do |sig|
          trap(sig, nil)
        end

        @signal_queue.clear
        @workers.clear
      end

      def kill_all_workers!(sig)
        @workers.each do |n, worker|
          Process.kill(sig, worker.pid)
        end
      end
  end
end
