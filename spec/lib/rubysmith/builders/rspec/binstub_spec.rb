# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::RSpec::Binstub do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:binstub_path) { temp_dir.join "test", "bin", "rspec" }

    context "when enabled" do
      before { settings.build_rspec = true }

      it "builds file" do
        builder.call

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

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.with! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(binstub_path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
