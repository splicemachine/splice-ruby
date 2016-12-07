# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record/jdbcsplice/adapter/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-jdbcsplice-adapter"
  spec.version       = Activerecord::Jdbcsplice::Adapter::VERSION
  spec.authors       = ["Kolosek"]
  spec.email         = ["office@kolosek.com"]

  spec.summary       = %q{Splice JDBC adapter for JRuby on Rails.}
  spec.description   = %q{Splice Engine JDBC adapter for JRuby on Rails.}
  spec.homepage      = "http://splicemachine.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord-jdbc-adapter', "~> 1.3.21"
  spec.add_dependency 'jdbc-splice', '~> 0.1.1'
end
