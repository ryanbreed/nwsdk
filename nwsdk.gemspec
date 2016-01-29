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
  spec.homepage      = 'http://github.com/ryanbreed/nwsdk'
  spec.license       = 'GPLv3'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'cef', '2.1.1pre'
  spec.add_dependency 'chronic'
  spec.add_dependency 'rest-client'
  spec.add_dependency 'thor'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'simplecov'
end
