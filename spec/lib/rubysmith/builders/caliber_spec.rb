# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Caliber do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:binstub_path) { temp_dir.join "test/bin/rubocop" }
    let(:settings_path) { temp_dir.join "test/.config/rubocop/config.yml" }

    context "when enabled" do
      before { settings.with! settings.minimize.with(build_caliber: true) }

      it "builds binstub" do
        builder.call

        expect(binstub_path.read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "bundler/setup"

          load Gem.bin_path "rubocop", "rubocop"
        CONTENT
      end

      it "updates binstub permissions" do
        builder.call
        expect(binstub_path.stat.mode).to eq(33261)
      end

      it "builds configuration" do
        builder.call

        expect(settings_path.read).to eq(<<~CONTENT)
          inherit_gem:
            caliber: config/all.yml
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.with! settings.minimize }

      it "doesn't build binstub" do
        builder.call
        expect(binstub_path.exist?).to be(false)
      end

      it "doesn't build configuration" do
        builder.call
        expect(settings_path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
