# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'basic_table_sorter/version'

Gem::Specification.new do |gem|
  gem.name          = "basic_table_sorter"
  gem.version       = BasicTableSorter::VERSION
  gem.authors       = ["Daniel Grawunder, Christian Mierich"]
  gem.email         = ["gramie.sw@gmail.com"]
  gem.description   = %q{A Ruby on Rails basic table sorter gem}
  gem.summary       = %q{An easy to use basic table sorter for Ruby on Rails.}
  gem.license       = "EPL 1.0"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "activesupport", "~>3.2"
  gem.add_development_dependency "guard-rspec", "~>2.6.0"
end
