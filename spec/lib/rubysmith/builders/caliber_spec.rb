# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Caliber do
  using Refinements::Pathnames
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:binstub_path) { temp_dir.join "test", "bin", "rubocop" }
  let(:configuration_path) { temp_dir.join "test", ".rubocop.yml" }

  it_behaves_like "a builder"

  describe "#call" do
    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_caliber: true }

      it "builds binstub" do
        builder.call

        expect(binstub_path.read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "bundler/setup"

          load Gem.bin_path "rubocop", "rubocop"
        CONTENT
      end

      it "updates file permissions" do
        builder.call
        expect(binstub_path.stat.mode).to eq(33261)
      end

      it "builds configuration" do
        builder.call

        expect(configuration_path.read).to eq(<<~CONTENT)
          inherit_gem:
            caliber: config/all.yml
        CONTENT
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't build binstub" do
        builder.call
        expect(binstub_path.exist?).to be(false)
      end

      it "doesn't build configuration" do
        builder.call
        expect(configuration_path.exist?).to be(false)
      end
    end
  end
end
