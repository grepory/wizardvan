require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Greg Poirer']
  gem.email         = ['greg.poirier@opower.com']
  gem.description  = <<-DESCRIPTION
Wizadvan: A Sensu Metrics Relay - Establishes persistent TCP connections to multiple
metrics backends and relays metrics to them. Optionally, Wizardvan can mutate from 
a common, unified JSON metric format to any number of formats expected by backend
metric stores.
  DESCRIPTION
  gem.summary       = 'Sensu Metrics Relay'
  gem.files         = `git ls-files`.split($\)
  gem.executables   = []
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'wizardvan'
  gem.require_paths = ['lib']
  gem.version       = Wizardvan::VERSION

  gem.add_dependency('sensu', '0.12.1')

  # development dependencies
  gem.add_development_dependency('rspec', '~> 2.13.0')
  gem.add_development_dependency('rake', '~> 10.1.0')
  gem.add_development_dependency('simplecov', '~> 0.7.0')
  gem.add_development_dependency('coveralls', '~> 0.6.7')
  gem.add_development_dependency('guard', '~> 1.8.0')
  gem.add_development_dependency('guard-rspec', '~> 3.0.1')
  gem.add_development_dependency('rubocop', '~> 0.8.3')
  gem.add_development_dependency('guard-rubocop', '~> 0.0.4')
  gem.add_development_dependency('metric_fu', '~> 4.2.0')
  gem.add_development_dependency('guard-reek', '~> 0.0.4')
end
