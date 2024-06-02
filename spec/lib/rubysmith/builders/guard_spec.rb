# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Guard do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    let(:binstub_path) { temp_dir.join "test/bin/guard" }
    let(:settings_path) { temp_dir.join "test/Guardfile" }

    context "when enabled" do
      before do
        settings.merge! settings.minimize.merge(build_guard: true)
        builder.call
      end

      it "builds binstub" do
        expect(binstub_path.read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "bundler/setup"

          load Gem.bin_path "guard", "guard"
        CONTENT
      end

      it "builds configuration" do
        expect(settings_path.read).to eq(<<~CONTENT)
          guard :rspec, cmd: "NO_COVERAGE=true bin/rspec --format documentation" do
            watch %r(^spec/.+_spec\\.rb$)
            watch(%r(^lib/(.+)\\.rb$)) { |m| "spec/lib/\#{m[1]}_spec.rb" }
            watch("spec/spec_helper.rb") { "spec" }
          end
        CONTENT
      end

      it "updates file permissions" do
        expect(binstub_path.stat.mode).to eq(33261)
      end
    end

    context "when disabled" do
      before do
        settings.merge! settings.minimize
        builder.call
      end

      it "doesn't build binstub" do
        expect(binstub_path.exist?).to be(false)
      end

      it "doesn't build configuration" do
        expect(settings_path.exist?).to be(false)
      end
    end
  end
end
