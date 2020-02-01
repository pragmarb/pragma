# frozen_string_literal: true

require_relative '../lib/pragma/version'

Gem::Specification.new do |spec|
  spec.name          = 'pragma-contract'
  spec.version       = Pragma::VERSION
  spec.authors       = ['Alessandro Desantis']
  spec.email         = ['desa.alessandro@gmail.com']

  spec.summary       = 'Form objects on steroids for your HTTP API.'
  spec.homepage      = 'https://github.com/pragmarb/pragma-contract'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'adaptor', '~> 0.2.1'
  spec.add_dependency 'dry-types', '~> 0.12.0'
  spec.add_dependency 'dry-validation', '~> 0.11.1'
  spec.add_dependency 'reform', '~> 2.2'
  spec.add_dependency 'zeitwerk', '~> 2.1'
end
