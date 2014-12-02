require 'optparse'

module Narwhal

  class Command

    def initialize(args)
      @options = {}
      @options[:environment] = "development"

      parse_options!(args)
    end

    def run!
      loop do
        sleep(1000)
      end
    end

    private

      def parse_options!(args)
        parser = OptionParser.new do |opts|
          opts.on("-e", "--environment ENVIRONMENT", "Set the environment (default: development)") do |env|
            @options[:environment] = env
          end

          opts.on_tail("-h", "--help", "Show help for command line options") do
            puts opts
            exit
          end
        end

        begin
          parser.parse!
        rescue OptionParser::InvalidOption => e
          puts e
          puts ""
          puts parser
          exit
        end
      end

  end
end
