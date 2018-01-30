# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'retrier'

Gem::Specification.new do |spec|
  spec.name          = 'retrier'
  spec.version       = Retrier::VERSION
  spec.authors       = ['Metrilo']
  spec.email         = ['support@metrilo.com']

  spec.summary       = 'Retry a ruby block.'
  spec.description   = 'Retry a ruby block.'
  spec.homepage      = 'https://github.com/Metrilo/retrier'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3'
  spec.add_development_dependency 'bundler', '~> 1.8'
end
