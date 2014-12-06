require 'logger'

module Narwhal

  def self.title=(title)
    $0 = "narwhal: #{title}"
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

end

require_relative 'narwhal/version'
require_relative 'narwhal/command'
require_relative 'narwhal/master'
require_relative 'narwhal/worker'
require_relative 'active_job/queue_adapters/narwhal_adapter'
