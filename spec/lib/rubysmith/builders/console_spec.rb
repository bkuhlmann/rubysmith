# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Console, :realm do
  subject(:builder) { described_class.new realm }

  let(:template_root) { Bundler.root.join "lib", "rubysmith", "templates" }
  let(:build_path) { temp_dir.join "test", "bin", "console" }

  it_behaves_like "a builder"

  describe "#call" do
    context "when enabled" do
      let(:realm) { default_realm.with build_console: true }

      it "builds console script" do
        proof = <<~CONTENT
          #! /usr/bin/env ruby

          require "bundler/setup"
          Bundler.require :tools

          require_relative "../lib/test"
          require "irb"

          IRB.start __FILE__
        CONTENT

        builder.call

        expect(build_path.read).to eq(proof)
      end

      it "updates file permissions" do
        builder.call
        expect(build_path.stat.mode).to eq(33261)
      end
    end

    context "when disabled" do
      let(:realm) { default_realm.with build_console: false }

      it "does not build console script" do
        builder.call
        expect(build_path.exist?).to eq(false)
      end
    end
  end
end
