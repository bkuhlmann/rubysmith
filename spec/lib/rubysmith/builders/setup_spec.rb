# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Setup do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test", "bin", "setup" }

    context "when enabled" do
      before { settings.merge! settings.minimize.merge(build_setup: true) }

      it "builds file" do
        builder.call

        expect(path.read).to eq(<<~'CONTENT')
          #! /usr/bin/env ruby

          require "fileutils"
          require "pathname"

          APP_ROOT = Pathname(__dir__).join("..").expand_path

          Runner = lambda do |*arguments, kernel: Kernel|
            kernel.system(*arguments) || kernel.abort("\nERROR: Command #{arguments.inspect} failed.")
          end

          FileUtils.chdir APP_ROOT do
            puts "Installing dependencies..."
            Runner.call "bundle install"
          end
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

    context "when enabled with debug" do
      before do
        settings.merge! settings.minimize.merge(build_setup: true, build_debug: true)
        builder.call
      end

      it "builds file" do
        expect(path.read).to eq(<<~'CONTENT')
          #! /usr/bin/env ruby

          require "debug"
          require "fileutils"
          require "pathname"

          APP_ROOT = Pathname(__dir__).join("..").expand_path

          Runner = lambda do |*arguments, kernel: Kernel|
            kernel.system(*arguments) || kernel.abort("\nERROR: Command #{arguments.inspect} failed.")
          end

          FileUtils.chdir APP_ROOT do
            puts "Installing dependencies..."
            Runner.call "bundle install"
          end
        CONTENT
      end

      it "updates file permissions" do
        expect(path.stat.mode).to eq(33261)
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
