# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-evernote/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Szymon Nowak"]
  gem.email         = ["szimek@gmail.com"]
  gem.description   = %q{OmniAuth strategy for Evernote}
  gem.summary       = %q{OmniAuth strategy for Evernote}
  gem.homepage      = "https://github.com/szimek/omniauth-evernote"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-evernote"
  gem.require_paths = ["lib"]
  gem.version       = Omniauth::Evernote::VERSION

  gem.add_runtime_dependency     'omniauth-oauth', '~> 1.0'
  gem.add_runtime_dependency     'evernote-thrift'
  gem.add_runtime_dependency     'multi_json', '~> 1.0'

  gem.add_development_dependency 'rspec', '~> 2.7'
  gem.add_development_dependency 'rake', '< 11.0'
end
