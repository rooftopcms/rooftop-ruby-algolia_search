# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rooftop/algolia_search/version'

Gem::Specification.new do |spec|
  spec.name          = "rooftop-algolia_search"
  spec.version       = Rooftop::AlgoliaSearch::VERSION
  spec.authors       = ["Ed Jones", "Paul Hendrick"]
  spec.email         = ["ed@error.agency", "paul@error.agency"]

  spec.summary       = %q{Search your Rooftop models using Algolia from your Ruby applications}
  spec.homepage      = "https://github.com/rooftopcms/rooftop-ruby-algolia_search"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "algoliasearch", "~> 1.0.0"
  spec.add_dependency "rooftop", "~> 0.1"
end
