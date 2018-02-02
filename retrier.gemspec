# frozen_string_literal: true

require_relative 'lib/retrier'

Gem::Specification.new do |spec|
  spec.name          = 'retrier'
  spec.version       = Retrier::VERSION
  spec.authors       = ['Metrilo']
  spec.email         = ['support@metrilo.com']

  spec.summary       = 'Retry a Ruby block for a specific error.'
  spec.description   = 'Retry a Ruby block for a specific error.'
  spec.homepage      = 'https://github.com/Metrilo/retrier'
  spec.files         = Dir.glob('lib/**/*') + %w[README.md]
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3'
  spec.add_development_dependency 'bundler', '~> 1.8'
end
