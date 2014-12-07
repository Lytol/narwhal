module ActiveJob
  module QueueAdapters
    # Read more about Narwhal {here}[https://github.com/lytol/narwhal].
    #
    # To use Narwhal set the queue_adapter config to +:narwhal+.
    #
    #   Rails.application.config.active_job.queue_adapter = :narwhal
    class NarwhalAdapter

      def self.enqueue(job) #:nodoc:
        Narwhal.adapter.enqueue(job.queue_name, job.serialize)
      end

      def self.enqueue_at(job, timestamp) #:nodoc:
        raise NotImplementedError, "Narwhal does not support scheduling of jobs"
      end

    end
  end
end
