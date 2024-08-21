# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Rake::Binstub do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/bin/rake" }

    context "when enabled" do
      before { settings.build_rake = true }

      it "builds binstub" do
        builder.call

        expect(path.read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "bundler/setup"

          load Gem.bin_path "rake", "rake"
        CONTENT
      end

      it "updates file permissions" do
        builder.call
        expect(path.stat.mode).to eq(33261)
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
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
