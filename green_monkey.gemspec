# encoding: utf-8

Gem::Specification.new do |s|
  s.name        = "green_monkey"
  s.version     = '0.2.2'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Pavel Evstigneev"]
  s.email       = ["pavel.evst@gmail.com"]
  s.homepage    = "https://github.com/paxa/green_monkey"
  s.summary     = "Rails and Haml microdata toolkit"
  s.description = "Provides useful helpers to map object with microdata types and display object's properties in view"
  s.license     = "MIT"

  s.required_rubygems_version = ">= 1.2.0"
  s.required_ruby_version = '>= 1.9'

  s.add_runtime_dependency 'haml', '>= 3.1.0'
  s.add_runtime_dependency 'mida_vocabulary', '>= 0.2.2'
  s.add_runtime_dependency 'chronic_duration'

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec", ">= 2.9.0"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "nokogiri"
  s.add_development_dependency 'sqlite3'

  s.files        = `git ls-files`.split("\n")
  s.executables  = []
  s.require_paths = ["lib"]
end

