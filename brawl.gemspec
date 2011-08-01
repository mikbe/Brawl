# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "brawl/version"

Gem::Specification.new do |s|
  s.name        = "brawl"
  s.version     = Brawl::VERSION
  s.authors     = ["Mike Bethany"]
  s.email       = ["mikbe.tk@gmail.com"]
  s.homepage    = "http://mikbe.tk"
  s.summary     = %q{A robot combat game where you write Ruby programs to control your robots.}
  s.description = %q{Write robotic assassins using Ruby and watch them as they do your evil bidding.}

  s.add_dependency "uuidtools"
  s.add_dependency "eventable"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
