# frozen_string_literal: true

require "spec_helper"
require "refinements/pathnames"

RSpec.describe Rubysmith::Builders::Rubocop, :realm do
  using Refinements::Pathnames

  subject(:builder) { described_class.new realm, runner: runner }

  let(:runner) { instance_spy RuboCop::CLI }
  let(:binstub_path) { temp_dir.join "test", "bin", "rubocop" }
  let(:configuration_path) { temp_dir.join "test", ".rubocop.yml" }

  it_behaves_like "a builder"

  describe "#call" do
    shared_examples_for "a binstub" do
      it "builds binstub" do
        builder.call

        expect(binstub_path.read).to eq(
          <<~CONTENT
            #! /usr/bin/env ruby
            # frozen_string_literal: true

            require "rubygems"
            require "bundler/setup"

            load Gem.bin_path "rubocop", "rubocop"
          CONTENT
        )
      end
    end

    context "when enabled with no options" do
      let(:realm) { default_realm.with build_rubocop: true }

      it_behaves_like "a binstub"

      it "builds configuration" do
        builder.call

        expect(configuration_path.read).to eq(
          <<~CONTENT
            inherit_from:
              - https://raw.githubusercontent.com/bkuhlmann/code_quality/master/configurations/rubocop/ruby.yml
              - https://raw.githubusercontent.com/bkuhlmann/code_quality/master/configurations/rubocop/rake.yml
              - https://raw.githubusercontent.com/bkuhlmann/code_quality/master/configurations/rubocop/performance.yml
          CONTENT
        )
      end
    end

    context "when enabled with RSpec only" do
      let(:realm) { default_realm.with build_rubocop: true, build_rspec: true }

      it_behaves_like "a binstub"

      it "builds configuration" do
        builder.call

        expect(configuration_path.read).to eq(
          <<~CONTENT
            inherit_from:
              - https://raw.githubusercontent.com/bkuhlmann/code_quality/master/configurations/rubocop/ruby.yml
              - https://raw.githubusercontent.com/bkuhlmann/code_quality/master/configurations/rubocop/rake.yml
              - https://raw.githubusercontent.com/bkuhlmann/code_quality/master/configurations/rubocop/performance.yml
              - https://raw.githubusercontent.com/bkuhlmann/code_quality/master/configurations/rubocop/rspec.yml
          CONTENT
        )
      end
    end

    context "when enabled" do
      let(:realm) { default_realm.with build_rubocop: true }

      it_behaves_like "a binstub"

      it "runs Rubocop" do
        builder.call

        expect(runner).to have_received(:run).with([
          "--auto-correct",
          "--format",
          "quiet",
          temp_dir.join("test").to_s
        ])
      end
    end

    context "when disabled" do
      let(:realm) { default_realm.with build_rubocop: false }

      it "doesn't build binstub" do
        builder.call
        expect(binstub_path.exist?).to eq(false)
      end

      it "doesn't build configuration" do
        builder.call
        expect(configuration_path.exist?).to eq(false)
      end
    end
  end
end
