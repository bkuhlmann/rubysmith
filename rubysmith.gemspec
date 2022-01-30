# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "rubysmith"
  spec.version = "1.2.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://github.com/bkuhlmann/rubysmith"
  spec.summary = "A command line interface for smithing Ruby projects."
  spec.license = "Hippocratic-3.0"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/rubysmith/issues",
    "changelog_uri" => "https://www.alchemists.io/projects/rubysmith/versions",
    "documentation_uri" => "https://www.alchemists.io/projects/rubysmith",
    "label" => "Rubysmith",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/rubysmith"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.1"
  spec.add_dependency "dry-container", "~> 0.9"
  spec.add_dependency "git_plus", "~> 1.1"
  spec.add_dependency "milestoner", "~> 13.0"
  spec.add_dependency "pastel", "~> 0.8"
  spec.add_dependency "pragmater", "~> 10.0"
  spec.add_dependency "refinements", "~> 9.1"
  spec.add_dependency "rubocop", "~> 1.25"
  spec.add_dependency "runcom", "~> 8.2"
  spec.add_dependency "tocer", "~> 13.0"
  spec.add_dependency "zeitwerk", "~> 2.5"

  spec.bindir = "exe"
  spec.executables << "rubysmith"
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir.glob ["*.gemspec", "lib/**/*"], File::FNM_DOTMATCH
end
