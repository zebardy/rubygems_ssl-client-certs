# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rubygems_client-certs/version"

Gem::Specification.new do |s|
  s.name = "rubygems_client-certs"
  s.version = Rubygems::ClientCerts::VERSION
  s.authors = ["Aaron Moses"]
  s.email = ["aaron.moses@bbc.co.uk"]
  s.homepage = "https://repo.dev.bbc.co.uk/playground/mosesa02/rubygems_client-certs"
  s.licenses = ["MIT"]
  s.summary = %q{Fix ssl client cert behavior in rubygems}
  s.description = %q{A rubygems plugin that monkey-patches rubygems to support ssl client certs}

  s.files = `svn list -R`.split("\n")
  s.test_files = `svn list -R`.split("\n").delete_if {|x| x !~ /^(test|spec|features)/}
  s.executables = `svn list -R`.split("\n").delete_if {|x| x !~ /^bin\//}
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
