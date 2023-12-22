# frozen_string_literal: true

require_relative "lib/GrokApi/version"

Gem::Specification.new do |spec|
  spec.name = "GrokApi"
  spec.version = GrokApi::VERSION
  spec.authors = ["Erik de Bruijn"]
  spec.email = ["me@erikdebruijn.nl"]

  spec.summary = "This gem can be used to interface with Grok AI."
  spec.homepage = "https://erikdebruijn.nl"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/erikdebruijn"
  spec.metadata["changelog_uri"] = "https://github.com/erikdebruijn"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_runtime_dependency "faraday", "~> 2.0"
  spec.add_dependency "webmock"
  spec.add_dependency "vcr"
  spec.add_dependency "dotenv"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
