# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nwsdk/version'

Gem::Specification.new do |spec|
  spec.name          = 'nwsdk'
  spec.version       = Nwsdk::VERSION
  spec.authors       = ['Ryan Breed']
  spec.email         = ['ryan.breed@ercot.com']

  spec.summary       = %q{ small wrapper around netwitness REST API }
  spec.description   = %q{ allows users to run queries, extracts, and generate cef alerts }
  spec.homepage      = 'http://www.ercot.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'cef', '~> 1.0'
  spec.add_dependency 'chronic', '0.10.2'
  spec.add_dependency 'rest-client', '~> 1.8'
  spec.add_dependency 'thor', '~> 0.19'

  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'guard', '~> 2.13'
  spec.add_development_dependency 'guard-rspec', '~> 4.6'
  spec.add_development_dependency 'simplecov', '~> 0.10'
end
