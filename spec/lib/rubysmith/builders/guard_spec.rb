# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Guard, :realm do
  subject(:builder) { described_class.new realm }

  let(:binstub_path) { temp_dir.join "test", "bin", "guard" }
  let(:configuration_path) { temp_dir.join "test", "Guardfile" }

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled" do
      let(:realm) { default_realm.with build_guard: true }

      it "builds binstub" do
        expect(binstub_path.read).to eq(
          <<~CONTENT
            #! /usr/bin/env ruby

            require "bundler/setup"

            load Gem.bin_path "guard", "guard"
          CONTENT
        )
      end

      it "builds configuration" do
        expect(configuration_path.read).to eq(
          <<~CONTENT
            guard :rspec, cmd: "bundle exec rspec --format documentation" do
              watch %r(^spec/.+_spec\\.rb$)
              watch(%r(^lib/(.+)\\.rb$)) { |m| "spec/lib/\#{m[1]}_spec.rb" }
              watch("spec/spec_helper.rb") { "spec" }
            end
          CONTENT
        )
      end
    end

    context "when disabled" do
      let(:realm) { default_realm.with build_guard: false }

      it "doesn't build binstub" do
        expect(binstub_path.exist?).to eq(false)
      end

      it "doesn't build configuration" do
        expect(configuration_path.exist?).to eq(false)
      end
    end
  end
end
