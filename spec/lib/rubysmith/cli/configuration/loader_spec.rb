# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Configuration::Loader do
  subject(:loader) { described_class.with_defaults }

  let :content do
    Rubysmith::CLI::Configuration::Content[
      build_amazing_print: true,
      build_bundler_leak: true,
      build_circle_ci: false,
      build_console: true,
      build_debug: true,
      build_git: true,
      build_git_hub: false,
      build_git_lint: true,
      build_guard: true,
      build_minimum: false,
      build_rake: true,
      build_reek: true,
      build_refinements: true,
      build_rspec: true,
      build_rubocop: true,
      build_setup: true,
      build_simple_cov: true,
      build_zeitwerk: true,
      builders_pragmater_comments: ["# frozen_string_literal: true"],
      builders_pragmater_includes: [
        "**/*.rb",
        "**/*bin/console",
        "**/*bin/guard",
        "**/*bin/rubocop",
        "**/*Gemfile",
        "**/*Guardfile",
        "**/*Rakefile"
      ],
      documentation_format: "md",
      documentation_license: "mit",
      git_hub_user: nil,
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
