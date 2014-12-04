require 'optparse'

module Narwhal

  class Command

    def initialize(args)
      @options = {}
      @options[:environment] = "development"
      @options[:worker_count] = 2

      parse_options!(args)

      @master = Master.new(@options)
    end

    def run!
      @master.run!
    end

    private

      def parse_options!(args)
        parser = OptionParser.new do |opts|
          opts.on("-e", "--environment ENVIRONMENT", "Set the environment to ENVIRONMENT (default: development)") do |env|
            @options[:environment] = env
          end

          opts.on("-n", "--workers NUM", Integer, "Set the number of workers to NUM (default: 2)") do |num|
            if num < 1
              raise(OptionParser::InvalidOption, "NUM must be at least 1")
            end

            @options[:worker_count] = num
          end

          opts.on_tail("-h", "--help", "Show help for command line options") do
            puts opts
            exit
          end
        end

        begin
          parser.parse!
        rescue OptionParser::InvalidOption, OptionParser::InvalidArgument => e
          puts e
          puts ""
          puts parser
          exit
        end
      end

  end
end
