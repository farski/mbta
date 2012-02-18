# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mbta/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Chris Kalafarski']
  gem.email         = ['chris@farski.com']
  gem.description   = %q{Library for accessing real-time MBTA data}
  gem.summary       = %q{Not a product of the MBTA. See mbta.com/developers for more info about their API}
  gem.homepage      = 'https://github.com/farski/mbta'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = 'mbta'
  gem.require_paths = ['lib']
  gem.version       = MBTA::VERSION

  gem.add_dependency('httparty', '>= 0.8.0')
end
