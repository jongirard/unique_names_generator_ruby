# frozen_string_literal: true

require_relative 'lib/unique_names_generator/version'

Gem::Specification.new do |s|
  s.name          = 'unique_names_generator'
  s.version       = UniqueNamesGenerator::VERSION
  s.summary       = 'Ruby library for generating random and unique names'
  s.description = <<~DESC
    Generate random and unique names in Ruby with support for PRNG
    seeded/deterministic generation using a built in collection of
    dictionaries, or your own.
  DESC
  s.authors       = ['Jon Girard']
  s.email         = 'jongirard03@gmail.com'
  s.homepage      = 'https://github.com/jongirard/unique_names_generator_ruby'
  s.metadata      = { 'homepage_uri' => 'https://github.com/jongirard/unique_names_generator_ruby',
                      'source_code_uri' => 'https://github.com/jongirard/unique_names_generator_ruby',
                      'documentation_uri' => 'https://jongirard.github.io/unique_names_generator_ruby' }
  s.require_paths = ['lib']
  s.license       = 'MIT'
  s.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  s.required_ruby_version = '>= 2.6.0'

  s.add_development_dependency 'rspec', '~> 3.0'
end
