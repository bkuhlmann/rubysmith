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
  spec.license = "Apache-2.0"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/rubysmith/issues",
    "changelog_uri" => "https://www.alchemists.io/projects/rubysmith/changes.html",
    "documentation_uri" => "https://www.alchemists.io/projects/rubysmith",
    "source_code_uri" => "https://github.com/bkuhlmann/rubysmith"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.0"
  spec.add_dependency "pragmater", "~> 8.1"
  spec.add_dependency "refinements", "~> 7.18"
  spec.add_dependency "rubocop", "~> 1.5"
  spec.add_dependency "runcom", "~> 6.4"

  spec.files = Dir.glob "lib/**/*", File::FNM_DOTMATCH
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.executables << "rubysmith"
  spec.require_paths = ["lib"]
end
