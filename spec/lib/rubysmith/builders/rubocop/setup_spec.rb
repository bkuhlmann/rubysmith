# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Rubocop::Setup, :realm do
  using Refinements::Pathnames

  subject(:builder) { described_class.new realm }

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

            require "bundler/setup"

            load Gem.bin_path "rubocop", "rubocop"
          CONTENT
        )
      end
    end

    context "when enabled with no additional options" do
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

    context "when enabled with RSpec" do
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
