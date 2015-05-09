Gem::Specification.new do |spec|
  spec.name          = 'lita-alias'
  spec.version       = '0.1.0.alpha'
  spec.authors       = ['Mike Fiedler']
  spec.email         = ['miketheman@gmail.com']
  spec.description   = 'Tell Lita about aliases for other commands'
  spec.summary       = 'Enable users to define custom command aliases.'
  spec.homepage      = 'https://github.com/miketheman/lita-alias'
  spec.license       = 'WTFPL'
  spec.metadata      = { 'lita_plugin_type' => 'handler' }

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'lita', '>= 4.3'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rspec', '>= 3.0.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
end
