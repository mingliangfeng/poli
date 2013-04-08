# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'poli/version'

Gem::Specification.new do |spec|
  spec.name          = "poli"
  spec.version       = Poli::VERSION
  spec.authors       = ["Andrew Feng"]
  spec.email         = ["mingliangfeng@gmail.com"]
  spec.description   = %q{API to integrate POLi payment gateway -- http://www.polipayments.com}
  spec.summary       = %q{API to integrate POLi payment gateway -- http://www.polipayments.com}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency "httparty"
  spec.add_dependency "nokogiri"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  
  spec.add_development_dependency "rspec", "~> 2.6"
end
