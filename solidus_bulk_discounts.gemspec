# encoding: UTF-8

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "solidus_bulk_discounts"
  s.version     = "1.0.0"
  s.summary     = "Configurable bulk discounts"
  s.required_ruby_version = ">= 2.1"

  s.author    = "Personal Wine"
  s.email     = "dev@personalwine.com"
  s.homepage  = "https://www.personalwine.com"
  s.license   = %q{BSD-3}

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = "lib"
  s.requirements << "none"

  s.add_dependency "pg"
  s.add_dependency "solidus_core", ['> 2.0', '<4']
  s.add_dependency "solidus_api", ['> 2.0', '<4']
  s.add_dependency "solidus_backend", ['> 2.0', '<4']

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-activemodel-mocks"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "sass-rails"
  s.add_development_dependency "coffee-rails"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "capybara"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "ffaker"
end
