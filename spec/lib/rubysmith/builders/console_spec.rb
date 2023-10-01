# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Console do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:build_path) { temp_dir.join "test/bin/console" }

  it_behaves_like "a builder"

  describe "#call" do
    context "when enabled with non-dashed project name" do
      let(:test_configuration) { configuration.minimize.merge build_console: true }

      it "builds console script" do
        builder.call

        expect(build_path.read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "bundler/setup"
          Bundler.require :tools

          require Bundler.root.join("lib/test").to_s
          require "irb"

          IRB.start __FILE__
        CONTENT
      end

      it "updates file permissions" do
        builder.call
        expect(build_path.stat.mode).to eq(33261)
      end
    end

    context "when enabled with dashed project name" do
      let :test_configuration do
        configuration.minimize.merge project_name: "demo-test", build_console: true
      end

      let(:build_path) { temp_dir.join "demo-test/bin/console" }

      it "builds console script" do
        builder.call

        expect(build_path.read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "bundler/setup"
          Bundler.require :tools

          require Bundler.root.join("lib/demo/test").to_s
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
      let(:test_configuration) { configuration.minimize }

      it "does not build console script" do
        builder.call
        expect(build_path.exist?).to be(false)
      end
    end
  end
end
