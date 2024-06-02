# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::GitHubCI do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    let(:yaml_path) { temp_dir.join "test/.github/workflows/ci.yml" }

    it "builds YAML template when enabled" do
      settings.merge! settings.minimize.merge(build_git_hub_ci: true)
      builder.call

      expect(yaml_path.read).to eq(<<~CONTENT)
        name: Continuous Integration

        on: [push, pull_request]

        jobs:
          build:
            name: Build
            runs-on: ubuntu-latest

            steps:
              - name: Checkout
                uses: actions/checkout@v4

              - name: Ruby Setup
                uses: ruby/setup-ruby@v1
                with:
                  bundler-cache: true

              - name: Build
                run: bundle exec rake
      CONTENT
    end

    it "builds YAML template when enabled with SimpleCov" do
      settings.merge! settings.minimize.merge(build_git_hub_ci: true, build_simple_cov: true)
      builder.call

      expect(yaml_path.read).to eq(<<~CONTENT)
        name: Continuous Integration

        on: [push, pull_request]

        jobs:
          build:
            name: Build
            runs-on: ubuntu-latest

            steps:
              - name: Checkout
                uses: actions/checkout@v4

              - name: Ruby Setup
                uses: ruby/setup-ruby@v1
                with:
                  bundler-cache: true

              - name: Build
                run: bundle exec rake

              - name: SimpleCov Report
                uses: actions/upload-artifact@v4
                with:
                  name: coverage
                  path: coverage
      CONTENT
    end

    it "does not build YAML template when disabled" do
      settings.merge! settings.minimize
      builder.call

      expect(yaml_path.exist?).to be(false)
    end
  end
end
