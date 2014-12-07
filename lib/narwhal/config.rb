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
      path: "config/narwhal.yml",
      environment: "development",
      workers: 2,
      adapter: nil
    }

    def initialize(options = {})
      @config = DEFAULT.dup.with_indifferent_access

      # Add environment and config file path first because we need
      # these to properly load the config file
      # config file correctly.
      @config[:path] = options[:path] if options[:path]
      @config[:environment] = options[:environment] if options[:environment]

      @config.merge!(config_file_options)
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

      def config_file_options
        YAML.load(File.read(@config[:path]))[environment]
      rescue
        raise(InvalidConfig, "The config file #{@config[:path]} is either missing or invalid")
      end
  end
end
