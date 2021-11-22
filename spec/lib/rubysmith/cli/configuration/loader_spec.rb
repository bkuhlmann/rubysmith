# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Configuration::Loader do
  subject(:loader) { described_class.with_defaults }

  let :content do
    Rubysmith::CLI::Configuration::Content[
      build_amazing_print: true,
      build_bundler_leak: true,
      build_changes: true,
      build_circle_ci: false,
      build_community: false,
      build_conduct: true,
      build_console: true,
      build_contributions: true,
      build_dead_end: true,
      build_debug: true,
      build_git: true,
      build_git_hub: false,
      build_git_lint: true,
      build_guard: true,
      build_license: true,
      build_maximum: false,
      build_minimum: false,
      build_rake: true,
      build_readme: true,
      build_reek: true,
      build_refinements: true,
      build_rspec: true,
      build_rubocop: true,
      build_setup: true,
      build_simple_cov: true,
      build_zeitwerk: true,
      community_url: nil,
      documentation_format: "adoc",
      documentation_url: nil,
      extensions_pragmater_comments: ["# frozen_string_literal: true"],
      extensions_pragmater_includes: [
        "**/*.rb",
        "**/*bin/console",
        "**/*bin/guard",
        "**/*bin/rubocop",
        "**/*Gemfile",
        "**/*Guardfile",
        "**/*Rakefile"
      ],
      git_hub_user: nil,
      license_label: "Hippocratic",
      license_name: "hippocratic",
      license_version: 3.0,
      now: nil
    ]
  end

  describe ".call" do
    it "answers default configuration" do
      expect(described_class.call).to be_a(Rubysmith::CLI::Configuration::Content)
    end
  end

  describe ".with_defaults" do
    it "answers default configuration" do
      expect(described_class.with_defaults.call).to eq(content)
    end
  end

  describe "#call" do
    it "answers default configuration" do
      expect(loader.call).to eq(content)
    end

    it "answers enhanced configuration" do
      now = Time.now

      loader = described_class.new enhancers: [
        Rubysmith::CLI::Configuration::Enhancers::CurrentTime.new(now)
      ]

      expect(loader.call).to have_attributes(now: now)
    end
  end
end
