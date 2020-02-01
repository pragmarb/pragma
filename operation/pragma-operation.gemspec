# frozen_string_literal: true

require_relative '../lib/pragma/version'

Gem::Specification.new do |spec|
  spec.name          = 'pragma-operation'
  spec.version       = Pragma::VERSION
  spec.authors       = ['Alessandro Desantis']
  spec.email         = ['desa.alessandro@gmail.com']

  spec.summary       = 'Business logic encapsulation for your JSON API.'
  spec.homepage      = 'https://github.com/pragmarb/pragma-operation'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'trailblazer-operation', '~> 0.4.1'
  spec.add_dependency 'zeitwerk', '~> 2.1'
end
