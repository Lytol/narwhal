require_relative "lib/narwhal"

Gem::Specification.new do |s|
  s.name        = 'narwhal'
  s.version     = Narwhal::VERSION
  s.summary     = "Narwhal is a worker server designed to take advantage of features in *nix kernels, inspired by Unicorn"
  s.authors     = [ "Brian Smith" ]
  s.email       = 'brian.e.smith@gmail.com'
  s.files       = [ "lib/narwhal.rb" ]
  s.homepage    = 'http://rubygems.org/gems/narwhal'
  s.license     = 'MIT'
end
