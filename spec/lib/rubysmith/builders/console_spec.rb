# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Console do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/bin/console" }

    context "when enabled with non-dashed project name" do
      it "builds file" do
        settings.merge! settings.minimize.merge(build_console: true)
        builder.call

        expect(path.read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "bundler/setup"
          Bundler.require :tools

          require Bundler.root.join("lib/test").to_s
          require "irb"

          IRB.start __FILE__
        CONTENT
      end

      it "updates file permissions" do
        settings.merge! settings.minimize.merge(build_console: true)
        builder.call

        expect(path.stat.mode).to eq(33261)
      end
    end

    context "when enabled with dashed project name" do
      let(:path) { temp_dir.join "demo-test/bin/console" }

      it "builds file" do
        settings.merge! settings.minimize.merge(project_name: "demo-test", build_console: true)
        builder.call

        expect(path.read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "bundler/setup"
          Bundler.require :tools

          require Bundler.root.join("lib/demo/test").to_s
          require "irb"

          IRB.start __FILE__
        CONTENT
      end

      it "updates file permissions" do
        settings.merge! settings.minimize.merge(project_name: "demo-test", build_console: true)
        builder.call

        expect(path.stat.mode).to eq(33261)
      end
    end

    it "answers true when enabled" do
      settings.build_console = true
      expect(builder.call).to be(true)
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
