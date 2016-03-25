# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'percona_ar/version'

Gem::Specification.new do |spec|
  spec.name          = "percona_ar"
  spec.version       = PerconaAr::VERSION
  spec.authors       = ["James Mac William"]
  spec.email         = ["jimmy.macwilliam@gmail.com"]

  spec.summary       = %q{Use Percona (pt-online-schema-change) for migrations generated with this tool, all activerecord helpers are available.}
  spec.homepage      = "https://github.com/jamesmacwilliam/percona_ar"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake",    "~> 10.0"
  spec.add_development_dependency "rails",   ">= 4.0.0"
  spec.add_development_dependency "mysql2",  ">= 0.3.0"
  spec.add_development_dependency "rspec"
end
