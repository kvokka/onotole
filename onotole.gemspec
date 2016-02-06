# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'onotole/version'
require 'date'

Gem::Specification.new do |s|
  s.required_ruby_version = ">= #{Onotole::RUBY_VERSION}"
  s.authors = ['kvokka','thoughtbot']
  s.date = Date.today.strftime('%Y-%m-%d')

  s.description = <<-HERE
Onotole is a base Rails project that you can upgrade. Use Onotole if you're in a
rush to build something amazing, Onotole knows what to do!
  HERE

  s.email = 'root_p@mail.ru'
  s.executables = ['onotole']
  s.extra_rdoc_files = %w(README.md LICENSE)
  s.files = `git ls-files`.split("\n")
  s.homepage = 'http://github.com/kvokka/onotole'
  s.license = 'MIT'
  s.name = 'onotole'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.summary = 'Generate a Rails app using Onotole knowledge with kvokka fingers.'
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Onotole::VERSION

  s.add_dependency 'bundler', '~> 1.3'
  s.add_dependency 'rails', Onotole::RAILS_VERSION

  s.add_development_dependency 'rspec', '~> 3.2'
end
