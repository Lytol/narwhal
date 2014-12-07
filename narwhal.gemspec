require 'rake'
require_relative 'lib/narwhal/version'

Gem::Specification.new do |s|
  s.name        = 'narwhal'
  s.version     = Narwhal::VERSION
  s.summary     = 'Narwhal is a Ruby prefork worker designed to be broker agnostic and take advantage of features in *nix kernels'
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

  s.add_dependency "activejob", '~> 4.2.0.rc2'
  s.add_dependency "activesupport", '~> 4.2.0.rc2'

  s.add_development_dependency "rake", '~> 10.0'
  s.add_development_dependency 'minitest', '~> 5.4'
end
