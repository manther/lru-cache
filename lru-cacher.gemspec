# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lru-cacher/version'

Gem::Specification.new do |spec|
  spec.name          = "lru-cacher"
  spec.version       = LRUCacher::VERSION
  spec.authors       = ["Manther"]
  spec.email         = ["jason.manther.young@gmail.com"]

  spec.summary       = %q{LRU Caching gem.}
  spec.description   = %q{LRU Caching gem.}
  spec.homepage      = "https://github.com/Manther/lru-cache"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('simplecov', '~> 0.10.0')                    # no 1.0 release out yet
  spec.add_development_dependency('simplecov-rcov', '~> 0.2.3')
end
