# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pragma/version'

Gem::Specification.new do |spec|
  spec.name          = 'pragma'
  spec.version       = Pragma::VERSION
  spec.authors       = ['Alessandro Desantis']
  spec.email         = ['desa.alessandro@gmail.com']

  spec.summary       = 'A pragmatic architecture for building JSON APIs with Ruby.'
  spec.homepage      = 'https://github.com/pragmarb/pragma'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'adaptor', '~> 0.2.1'
  spec.add_dependency 'pragma-contract', '~> 2.0'
  spec.add_dependency 'pragma-decorator', '~> 2.0'
  spec.add_dependency 'pragma-operation', '~> 2.0'
  spec.add_dependency 'pragma-policy', '~> 2.0'
  spec.add_dependency 'trailblazer', '~> 2.0'
  spec.add_dependency 'zeitwerk', '~> 2.1'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'will_paginate'
end
