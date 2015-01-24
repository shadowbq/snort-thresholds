# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'threshold/version'

Gem::Specification.new do |s|
  s.name = 'threshold'
  s.version = Threshold::VERSION
  s.license = 'MIT'

  s.authors = ["Shadowbq", "Yabbo"]
  s.description = "An ORM to map to Snort 2.9.x threshold.conf files"
  s.email = "shadowbq@gmail.com"

  s.files = Dir.glob("{lib}/**/*") + %w(Rakefile README.md LICENSE CONTRIBUTING.md CHANGELOG.md)
  s.homepage = 'http://github.com/shadowbq/snort-thresholds'
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.summary = %q{An ORM to map to Snort 2.9.x threshold.conf files}
  s.test_files = Dir.glob("spec/**/*")

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'veto', '~> 1.0'
  s.add_dependency 'jls-grok', '~> 0.11.0'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'fivemat'
  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'codeclimate-test-reporter'
end