module Narwhal

  def self.log(msg)
    $stdout.puts(msg)
  end

end

require_relative 'narwhal/command'
require_relative 'narwhal/master'
require_relative 'narwhal/version'
