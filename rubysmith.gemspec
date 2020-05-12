# frozen_string_literal: true

require_relative "lib/rubysmith/identity"

Gem::Specification.new do |spec|
  spec.name = Rubysmith::Identity::NAME
  spec.version = Rubysmith::Identity::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://github.com/bkuhlmann/rubysmith"
  spec.summary = Rubysmith::Identity::SUMMARY
  spec.license = "MIT"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/rubysmith/issues",
    "changelog_uri" => "https://www.alchemists.io/projects/rubysmith/changes.html",
    "documentation_uri" => "https://www.alchemists.io/projects/rubysmith",
    "source_code_uri" => "https://github.com/bkuhlmann/rubysmith"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 2.7"
  spec.add_dependency "pragmater", "~> 8.0"
  spec.add_dependency "refinements", "~> 7.10"
  spec.add_dependency "rubocop", "~> 0.92"
  spec.add_dependency "runcom", "~> 6.2"
  spec.add_development_dependency "bundler-audit", "~> 0.7"
  spec.add_development_dependency "gemsmith", "~> 14.6"
  spec.add_development_dependency "git-lint", "~> 1.0"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "pry", "~> 0.13"
  spec.add_development_dependency "pry-byebug", "~> 3.9"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "reek", "~> 6.0"
  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "rubocop-performance", "~> 1.8"
  spec.add_development_dependency "rubocop-rake", "~> 0.5"
  spec.add_development_dependency "rubocop-rspec", "~> 1.43"
  spec.add_development_dependency "simplecov", "~> 0.19"

  spec.files = Dir.glob "lib/**/*", File::FNM_DOTMATCH
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.executables << "rubysmith"
  spec.require_paths = ["lib"]
end
