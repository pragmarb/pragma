# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
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

  spec.add_dependency 'pragma-contract', Pragma::VERSION
  spec.add_dependency 'pragma-decorator', Pragma::VERSION
  spec.add_dependency 'pragma-operation', Pragma::VERSION
  spec.add_dependency 'pragma-policy', Pragma::VERSION

  spec.add_development_dependency 'bundler'
end
