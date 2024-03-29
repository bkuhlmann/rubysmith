# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Guard do
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:binstub_path) { temp_dir.join "test", "bin", "guard" }
  let(:configuration_path) { temp_dir.join "test", "Guardfile" }

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_guard: true }

      it "builds binstub" do
        expect(binstub_path.read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "bundler/setup"

          load Gem.bin_path "guard", "guard"
        CONTENT
      end

      it "builds configuration" do
        expect(configuration_path.read).to eq(<<~CONTENT)
          guard :rspec, cmd: "NO_COVERAGE=true bin/rspec --format documentation" do
            watch %r(^spec/.+_spec\\.rb$)
            watch(%r(^lib/(.+)\\.rb$)) { |m| "spec/lib/\#{m[1]}_spec.rb" }
            watch("spec/spec_helper.rb") { "spec" }
          end
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

      it "doesn't build configuration" do
        expect(configuration_path.exist?).to be(false)
      end
    end
  end
end
