# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Console, :realm do
  subject(:builder) { described_class.new realm }

  let(:template_root) { Bundler.root.join "lib", "rubysmith", "templates" }
  let(:build_path) { temp_dir.join "test", "bin", "console" }

  it_behaves_like "a builder"

  describe "#call" do
    context "when enabled with Pry enabled" do
      let(:realm) { default_realm.with build_console: true, build_pry: true }

      it "builds console script without Pry support" do
        proof = <<~CONTENT
          #! /usr/bin/env ruby

          require "bundler/setup"
          require "test"
          require "pry"
          require "pry-byebug"
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

    context "when enabled and Pry disabled" do
      let(:realm) { default_realm.with build_console: true, build_pry: false }

      it "builds console script without Pry support" do
        proof = <<~CONTENT
          #! /usr/bin/env ruby

          require "bundler/setup"
          require "test"
          require "irb"

          IRB.start __FILE__
        CONTENT

        builder.call

        expect(build_path.read).to eq(proof)
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
