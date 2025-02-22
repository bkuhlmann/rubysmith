# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::GitHub::CI do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/.github/workflows/ci.yml" }

    it "builds YAML template when enabled" do
      settings.merge! settings.minimize.merge(build_git_hub_ci: true)
      builder.call

      expect(path.read).to eq(<<~CONTENT)
        name: Continuous Integration

        on: [push, pull_request]

        jobs:
          build:
            name: Build
            runs-on: ubuntu-latest

            steps:
              - name: System Update
                run: |
                  sudo apt-get update
                  sudo apt-get install --no-install-recommends -y curl libjemalloc2

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

      expect(path.read).to eq(<<~CONTENT)
        name: Continuous Integration

        on: [push, pull_request]

        jobs:
          build:
            name: Build
            runs-on: ubuntu-latest

            steps:
              - name: System Update
                run: |
                  sudo apt-get update
                  sudo apt-get install --no-install-recommends -y curl libjemalloc2

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

    it "builds YAML template when enabled with Git Lint" do
      settings.merge! settings.minimize.merge(build_git_hub_ci: true, build_git_lint: true)
      builder.call

      expect(path.read).to eq(<<~CONTENT)
        name: Continuous Integration

        on: [push, pull_request]

        jobs:
          build:
            name: Build
            runs-on: ubuntu-latest

            steps:
              - name: System Update
                run: |
                  sudo apt-get update
                  sudo apt-get install --no-install-recommends -y curl libjemalloc2

              - name: Checkout
                uses: actions/checkout@v4
                with:
                  fetch-depth: 0
                  ref: ${{github.head_ref}}

              - name: Ruby Setup
                uses: ruby/setup-ruby@v1
                with:
                  bundler-cache: true

              - name: Build
                run: bundle exec rake
      CONTENT
    end

    it "answers true when enabled" do
      settings.build_git_hub_ci = true
      expect(builder.call).to be(true)
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
