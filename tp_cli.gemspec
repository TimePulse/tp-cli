# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tp-cli/version'


Gem::Specification.new do |s|
  s.name        = 'tp-cli'
  s.version     = '1.0.0'
  s.date        = '2015-09-18'
  s.summary     = 'Timepulse Command Line Interface'
  s.description = 'CLI tool for submitting activity information to Timepulse'
  s.authors     = ["Anne Vetto", "Evan Dorn"]
  s.email       = 'evan@lrdesign.com'
  s.files       = ["lib/tp_cli.rb"]
  s.homepage    = 'https://github.com/TimePulse/tp-cli'
  s.license     = 'MIT'
end
