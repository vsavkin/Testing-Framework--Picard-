# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "picard/version"

Gem::Specification.new do |s|
  s.name        = "picard"
  s.version     = Picard::VERSION
  s.authors     = ["Victor Savkin"]
  s.email       = ["vic.savkin@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Test framework inspired by Spock}
  s.description = %q{Test framework inspired by Spock}

  s.rubyforge_project = "picard"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'live_ast', '= 1.0.2'
  s.add_dependency 'live_ast_ripper', '= 0.6.5'
  s.add_development_dependency 'flexmock'
end
