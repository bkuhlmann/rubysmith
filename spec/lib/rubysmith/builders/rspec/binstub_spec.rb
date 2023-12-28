# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::RSpec::Binstub do
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:binstub_path) { temp_dir.join "test", "bin", "rspec" }

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_rspec: true }

      it "builds binstub" do
        expect(binstub_path.read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "bundler/setup"

          load Gem.bin_path "rspec-core", "rspec"
        CONTENT
      end

      it "updates file permissions" do
        builder.call
        expect(binstub_path.stat.mode).to eq(33261)
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't build binstub" do
        expect(binstub_path.exist?).to be(false)
      end
    end
  end
end
