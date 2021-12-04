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
  spec.license = "Hippocratic-3.0"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/rubysmith/issues",
    "changelog_uri" => "https://www.alchemists.io/projects/rubysmith/changes.html",
    "documentation_uri" => "https://www.alchemists.io/projects/rubysmith",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/rubysmith"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.0"
  spec.add_dependency "dry-container", "~> 0.9"
  spec.add_dependency "git_plus", "~> 0.6"
  spec.add_dependency "milestoner", "~> 13.0"
  spec.add_dependency "pastel", "~> 0.8"
  spec.add_dependency "pragmater", "~> 9.0"
  spec.add_dependency "refinements", "~> 8.5"
  spec.add_dependency "rubocop", "~> 1.24"
  spec.add_dependency "runcom", "~> 7.0"
  spec.add_dependency "tocer", "~> 12.1"
  spec.add_dependency "zeitwerk", "~> 2.5"

  spec.bindir = "exe"
  spec.executables << "rubysmith"
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir.glob "lib/**/*", File::FNM_DOTMATCH
  spec.require_paths = ["lib"]
end
