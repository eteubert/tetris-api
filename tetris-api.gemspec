# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tetris-api/version"

Gem::Specification.new do |s|
  s.name        = "tetris-api"
  s.version     = Tetris::Api::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eric Teubert"]
  s.email       = ["ericteubert@googlemail.com"]
  s.homepage    = ""
  s.summary     = %q{A simple Tetris API}
  s.description = %q{Libraries to make Tetris computations easy. Plus some board metrics.}

  s.rubyforge_project = "tetris-api"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
