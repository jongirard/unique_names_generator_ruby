# frozen_string_literal: true

require 'unique_names_generator/version'

Gem::Specification.new do |s|
  s.name          = 'unique_names_generator'
  s.version       = UniqueNamesGenerator::VERSION
  s.summary       = 'Ruby library for generating unique names'
  s.description   = 'Generate random and unique names utilizing PRNG with seeds support'
  s.authors       = ['Jon Girard']
  s.email         = 'jongirard03@gmail.com'
  s.homepage      = 'https://github.com/jongirard/unique_names_generator_ruby'
  s.require_paths = ['lib']
  s.license       = 'MIT'
  s.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  s.required_ruby_version = '>= 2.7.0'
end
