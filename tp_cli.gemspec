# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tp_cli/version'


Gem::Specification.new do |spec|
  spec.name           = 'tp-cli'
  spec.version        = tp_cli::VERSION
  spec.date           = '2015-09-18'
  spec.summary        = 'Timepulse Command Line Interface'
  spec.description    = 'CLI tool for submitting activity information to Timepulse'
  spec.authors        = ["Anne Vetto", "Evan Dorn"]
  spec.email          = 'evan@lrdesign.com'
  spec.homepage       = 'https://github.com/TimePulse/tp-cli'
  spec.license        = 'MIT'

  spec.files          = `git ls-files`.split($\)
  spec.executables    = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files     = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths  = ["lib"]

  spec.add_development_dependency 'bundler', '~>1.10'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
