# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rubygems_ssl-client-certs/version"

Gem::Specification.new do |s|
  s.name = "rubygems_ssl-client-certs"
  s.version = Rubygems::ClientCerts::VERSION
  s.version = "#{s.version}-alpha-#{ENV['TRAVIS_BUILD_NUMBER']}" if ENV['TRAVIS']
  s.authors = ["Aaron Moses"]
  s.homepage = "https://github.com/zebardy/rubygems_ssl-client-certs"
  s.licenses = ["MIT"]
  s.summary = %q{Fix ssl client cert behavior in rubygems}
  s.description = %q{A rubygems plugin that monkey-patches rubygems to support ssl client certs}

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependancy "rubygems" '<=2.0.4'
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-core"
  s.add_development_dependency "mime-types", '1.25' if RUBY_VERSION < "1.9"
#  s.add_development_dependency "simplecov", '~> 0.7.1'
  s.add_development_dependency "coveralls"
end
