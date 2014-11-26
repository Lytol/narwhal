require 'rake'
require_relative 'lib/narwhal/version'

Gem::Specification.new do |s|
  s.name        = 'narwhal'
  s.version     = Narwhal::VERSION
  s.summary     = 'Narwhal is a worker server designed to take advantage of features in *nix kernels, inspired by Unicorn'
  s.authors     = [ 'Brian Smith' ]
  s.email       = 'brian.e.smith@gmail.com'
  s.files       = FileList[
                    '[README,LICENSE]*',
                    'lib/**/*.rb',
                    'bin/*'
                  ].to_a
  s.executables << 'narwhal'
  s.homepage    = 'https://github.com/lytol/narwhal'
  s.license     = 'MIT'

  s.add_development_dependency "rake", '~> 10.0'
  s.add_development_dependency 'minitest', '~> 5.4'
end
