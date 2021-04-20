# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Console do
  subject(:builder) { described_class.new configuration }

  include_context "with configuration"

  let(:template_root) { Bundler.root.join "lib", "rubysmith", "templates" }
  let(:build_path) { temp_dir.join "test", "bin", "console" }

  it_behaves_like "a builder"

  describe "#call" do
    context "when enabled" do
      let(:configuration) { default_configuration.with build_console: true }

      it "builds console script" do
        builder.call

        expect(build_path.read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "bundler/setup"
          Bundler.require :tools

          require_relative "../lib/test"
          require "irb"

          IRB.start __FILE__
        CONTENT
      end

      it "updates file permissions" do
        builder.call
        expect(build_path.stat.mode).to eq(33261)
      end
    end

    context "when disabled" do
      let(:configuration) { default_configuration.with build_console: false }

      it "does not build console script" do
        builder.call
        expect(build_path.exist?).to eq(false)
      end
    end
  end
end
