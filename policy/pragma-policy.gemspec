# frozen_string_literal: true

require_relative '../lib/pragma/version'

Gem::Specification.new do |spec|
  spec.name          = 'pragma-policy'
  spec.version       = Pragma::VERSION
  spec.authors       = ['Alessandro Desantis']
  spec.email         = ['desa.alessandro@gmail.com']

  spec.summary       = 'Fine-grained access control for your API resources.'
  spec.homepage      = 'https://github.com/pragmarb/pragma-policy'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'zeitwerk', '~> 2.1'
end
