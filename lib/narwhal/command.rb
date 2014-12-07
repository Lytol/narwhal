require 'optparse'

module Narwhal

  class Command

    def initialize(args)
      Narwhal.config = parse_options(args)
      @master = Master.new
    end

    def run!
      @master.run!
    end

    private

      def parse_options(args)
        options = {}

        parser = OptionParser.new do |opts|
          opts.on("-c", "--config PATH", "Set the config to PATH (default: #{Config::DEFAULT[:config_path]})") do |path|
            options[:path] = path
          end

          opts.on("-e", "--environment ENVIRONMENT", "Set the environment to ENVIRONMENT (default: #{Config::DEFAULT[:environment]})") do |env|
            options[:environment] = env
          end

          opts.on("-n", "--workers NUM", Integer, "Set the number of workers to NUM (default: #{Config::DEFAULT[:workers]})") do |num|
            options[:workers] = num
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

        return options
      end

  end
end
