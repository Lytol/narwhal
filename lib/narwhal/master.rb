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
          break
        when :QUIT # Terminate abruptly
          Narwhal.log("master signal=QUIT")
          break
        when :HUP # TODO
          Narwhal.log("master signal=HUP")
        when :USR1 # TODO
          Narwhal.log("master signal=USR1")
        when :USR2 # TODO
          Narwhal.log("master signal=USR2")
        else
          # TODO: Wait for next message, pass along to available worker
          sleep(1)
        end
      end

      reap_workers!

      Narwhal.log("master stopped=true")
    end

    private

      def initialize_signal_handlers!
        SIGNALS.each do |sig|
          trap(sig) { @signal_queue << sig }
        end
      end

      def spawn_workers!
        (1..worker_count).each do |index|
          next if @workers.any? { |w| w.index == index }

          worker = Worker.new(index)

          if pid = fork
            @workers[pid] = worker
            Narwhal.log("master.spawned index=#{index} pid=#{pid}")
          else
            reset_for_worker!
            worker.run!
            exit!(0)
          end
        end
      end

      def reap_workers!
        signal_workers!(:TERM)

        loop do
          begin
            pid = Process.wait
            worker = @workers.delete(pid)
            Narwhal.log("master.reaped index=#{worker.index} pid=#{pid}")
          rescue Errno::ECHILD
            # No more children, let's get out of here
            break
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

      def signal_workers!(sig)
        @workers.each do |pid, worker|
          Process.kill(sig, pid)
        end
      end
  end
end
