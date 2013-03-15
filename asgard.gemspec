# -*- encoding: utf-8 -*-
require File.expand_path('../lib/asgard/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tony La"]
  gem.email         = ["tonyla@pingg.com"]
  gem.description   = %q{Write a gem description}
  gem.summary       = %q{Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "asgard"
  gem.require_paths = ["lib"]
  gem.version       = Asgard::VERSION
  gem.add_dependency 'aws-sdk'
  gem.add_dependency "activesupport", "> 3.0.0"
  gem.add_dependency 'thor'
  gem.add_dependency 'sprinkle'
end
