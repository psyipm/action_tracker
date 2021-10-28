# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'action_tracker/version'

Gem::Specification.new do |spec|
  spec.name          = 'action_tracker_client'
  spec.version       = ActionTracker::VERSION
  spec.authors       = ['Igor Malinovskiy']
  spec.email         = ['igor.malinovskiy@netfixllc.org']

  spec.summary       = 'ActionTracking service client gem'
  spec.description   = 'ActionTracking service integration gem'
  spec.homepage      = 'https://github.com/psyipm/action_tracker'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'guard-rspec', '~> 4.7', '>= 4.7.3'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 3.5', '>= 3.5.1'

  spec.add_development_dependency 'pry-byebug'

  spec.add_dependency 'activemodel', '>= 4.0'
  spec.add_dependency 'activesupport', '>= 4.0'
  spec.add_dependency 'api_signature', '~> 0.1.5'
  spec.add_dependency 'httparty'
  spec.add_dependency 'model_auditor', '~> 0.0.2'

  spec.add_dependency 'virtus'
end
