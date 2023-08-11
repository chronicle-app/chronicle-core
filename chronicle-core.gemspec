# frozen_string_literal: true

require_relative "lib/chronicle/core/version"

Gem::Specification.new do |spec|
  spec.name = "chronicle-core"
  spec.version = Chronicle::Core::VERSION
  spec.authors = ["Andrew Louis"]
  spec.email = ["andrew@hyfen.net"]

  spec.summary       = "Core libraries for Chronicle"
  spec.description   = "Core libraries for Chronicle including models and schema definitions."
  spec.homepage      = "https://github.com/chronicle-app"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7"

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/chronicle-app/chronicle-core"
    spec.metadata["changelog_uri"] = "https://github.com/chronicle-app/chronicle-core/releases"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dry-schema", "~> 1.13"

  spec.add_development_dependency "guard-rspec", "~> 4.7.3"
  spec.add_development_dependency "pry-byebug", "~> 3.9"
  spec.add_development_dependency "rubocop", "~> 1.25.1"
  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "simplecov", "~> 0.21"
end
