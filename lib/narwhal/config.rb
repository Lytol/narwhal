require 'yaml'
require 'active_support/core_ext/hash'

module Narwhal

  class InvalidConfig < StandardError; end

  # Configuration for Narwhal for both ActiveJob and the `narwhal` command
  #
  # Order of precedence, highest to lowest:
  #
  #   1) Command-line attributes
  #   2) Config file attributes
  #   3) Default attributes
  #
  #   NOTE: Setting `environment` in the config file has no effect because
  #   the environment is required to load the proper configuration from the
  #   file.
  #
  class Config
    DEFAULT = {
      environment: "development",
      workers: 2,
      adapter: nil
    }

    def initialize(options = {}, path = "config/narwhal.yml")
      @config = DEFAULT.dup.with_indifferent_access

      # Add envrionment from command-line first, to maintain precedence
      @config[:environment] = options[:environment] if options[:environment]

      @config.merge!(config_file_options(path))
      @config.merge!(options)
    end

    def to_hash
      @config
    end

    private

      def method_missing(attr, *args)
        if [:environment, :workers, :adapter].include?(attr) && args.empty?
          @config[attr]
        else
          super
        end
      end

      def config_file_options(path)
        YAML.load(File.read(path))[environment]
      rescue
        raise(InvalidConfig, "The config file #{path} is either missing or invalid")
      end
  end
end
