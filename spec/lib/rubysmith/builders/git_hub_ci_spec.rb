# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::GitHubCI do
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  let(:yaml_path) { temp_dir.join "test/.github/workflows/ci.yml" }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_git_hub_ci: true }

      it "does not build YAML template" do
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
                  uses: actions/checkout@v3

                - name: Ruby Setup
                  uses: ruby/setup-ruby@v1
                  with:
                    bundler-cache: true

                - name: Build
                  run: bundle exec rake
        CONTENT
      end
    end

    context "when enabled with SimpleCov" do
      let :test_configuration do
        configuration.minimize.merge build_git_hub_ci: true, build_simple_cov: true
      end

      it "does not build YAML template" do
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
                  uses: actions/checkout@v3

                - name: Ruby Setup
                  uses: ruby/setup-ruby@v1
                  with:
                    bundler-cache: true

                - name: Build
                  run: bundle exec rake

                - name: SimpleCov Report
                  uses: actions/upload-artifact@v3
                  with:
                    name: coverage
                    path: coverage
        CONTENT
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "does not build YAML template" do
        builder.call
        expect(yaml_path.exist?).to be(false)
      end
    end
  end
end
