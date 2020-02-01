# frozen_string_literal: true

require_relative '../lib/pragma/version'

Gem::Specification.new do |spec|
  spec.name          = 'pragma-decorator'
  spec.version       = Pragma::VERSION
  spec.authors       = ['Alessandro Desantis']
  spec.email         = ['desa.alessandro@gmail.com']

  spec.summary       = 'Convert your API resources into JSON with minimum hassle.'
  spec.homepage      = 'https://github.com/pragmarb/pragma-decorator'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'adaptor', '~> 0.2.1'
  spec.add_dependency 'multi_json', '~> 1.12'
  spec.add_dependency 'roar', '~> 1.0'
  spec.add_dependency 'zeitwerk', '~> 2.1'
end
