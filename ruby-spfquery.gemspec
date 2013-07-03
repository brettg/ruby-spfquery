# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'spfquery/version'

Gem::Specification.new do |gem|
  gem.name          = "ruby-spfquery"
  gem.version       = '0.0.1'
  gem.authors       = ['Brett Gibson']
  gem.email         = ['bdg@brettdgibson.com']
  gem.description   = %q{very thin ruby wrapper for spfquery cli}
  gem.summary       = %q{very thin ruby wrapper for spfquery cli}
  gem.required_ruby_version = '>= 1.9.2'

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.require_paths = ['lib']
end
