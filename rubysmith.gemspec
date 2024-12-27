# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "rubysmith"
  spec.version = "7.9.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://alchemists.io/projects/rubysmith"
  spec.summary = "A command line interface for smithing Ruby projects."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/rubysmith/issues",
    "changelog_uri" => "https://alchemists.io/projects/rubysmith/versions",
    "homepage_uri" => "https://alchemists.io/projects/rubysmith",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "Rubysmith",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/rubysmith"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.4"
  spec.add_dependency "cogger", "~> 0.31"
  spec.add_dependency "containable", "~> 1.0"
  spec.add_dependency "dry-monads", "~> 1.6"
  spec.add_dependency "dry-schema", "~> 1.13"
  spec.add_dependency "etcher", "~> 2.7"
  spec.add_dependency "gitt", "~> 3.12"
  spec.add_dependency "infusible", "~> 3.12"
  spec.add_dependency "pragmater", "~> 15.7"
  spec.add_dependency "refinements", "~> 13.0"
  spec.add_dependency "rubocop", "~> 1.66"
  spec.add_dependency "runcom", "~> 11.10"
  spec.add_dependency "sod", "~> 0.20"
  spec.add_dependency "spek", "~> 3.0"
  spec.add_dependency "tocer", "~> 18.7"
  spec.add_dependency "tone", "~> 1.10"
  spec.add_dependency "zeitwerk", "~> 2.7"

  spec.bindir = "exe"
  spec.executables << "rubysmith"
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir.glob ["*.gemspec", "lib/**/*"], File::FNM_DOTMATCH
end
