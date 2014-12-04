require 'time'

module Narwhal

  def self.title=(title)
    $0 = "narwhal: #{title}"
  end

  def self.log(msg)
    $stdout.puts("#{Time.now.iso8601} #{$$} #{msg}")
  end

end

require_relative 'narwhal/version'
require_relative 'narwhal/command'
require_relative 'narwhal/master'
require_relative 'narwhal/worker'
