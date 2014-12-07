module Narwhal

  class Master
    SIGNALS = [ :INT, :QUIT, :TERM, :HUP, :USR1, :USR2 ]

    def initialize
      @pid = $$
      @signal_queue = []
      @workers = {}
    end

    def run!
      Narwhal.logger.info("master started=true environment=#{Narwhal.config.environment} workers=#{Narwhal.config.workers}")

      initialize_signal_handlers!
      spawn_workers!

      Narwhal.title = "master ready"

      loop do
        case @signal_queue.shift
        when :INT, :TERM # Terminate gracefully
          Narwhal.logger.debug("master signal=INT")
          break
        when :QUIT # Terminate abruptly
          Narwhal.logger.debug("master signal=QUIT")
          break
        when :HUP # TODO
          Narwhal.logger.debug("master signal=HUP")
        when :USR1 # TODO
          Narwhal.logger.debug("master signal=USR1")
        when :USR2 # TODO
          Narwhal.logger.debug("master signal=USR2")
        else
          # TODO: Wait for next message, pass along to available worker
          sleep(1)
        end
      end

      reap_workers!

      Narwhal.logger.info("master stopped=true")
    end

    private

      def initialize_signal_handlers!
        SIGNALS.each do |sig|
          trap(sig) { @signal_queue << sig }
        end
      end

      def spawn_workers!
        num = Narwhal.config.workers.to_i

        (1..num).each do |index|
          next if @workers.any? { |w| w.index == index }

          worker = Worker.new(index)

          if pid = fork
            @workers[pid] = worker
            Narwhal.logger.info("master.spawned index=#{index} pid=#{pid}")
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
            Narwhal.logger.info("master.reaped index=#{worker.index} pid=#{pid}")
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
