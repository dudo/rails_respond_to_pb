# frozen_string_literal: true

require_relative 'lib/rails_respond_to_pb/version'

Gem::Specification.new do |spec|
  spec.name          = 'rails_respond_to_pb'
  spec.version       = RailsRespondToPb::VERSION
  spec.authors       = ['Brett C. Dudo']
  spec.email         = ['brett@dudo.io']

  spec.summary       = 'Middleware for a Rails App providing functionality for gRPC and Twirp'
  spec.description   = 'Middleware for a Rails App providing functionality for gRPC and Twirp'
  spec.homepage      = 'https://github.com/dudo/rails_respond_to_pb'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.0.0')

  # spec.metadata['allowed_push_host'] = 'http://mygemserver.com'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rails', ENV['RAILS_VERSION'] || '>= 6'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
