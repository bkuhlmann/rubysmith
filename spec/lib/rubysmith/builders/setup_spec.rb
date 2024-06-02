# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Setup do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    let(:build_path) { temp_dir.join "test", "bin", "setup" }

    context "when enabled" do
      before do
        settings.merge! settings.minimize.merge(build_setup: true)
        builder.call
      end

      it "builds setup script without Pry support" do
        builder.call

        expect(build_path.read).to eq(<<~'CONTENT')
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

      it "updates script permissions" do
        builder.call
        expect(build_path.stat.mode).to eq(33261)
      end
    end

    context "when enabled with debug" do
      before do
        settings.merge! settings.minimize.merge(build_setup: true, build_debug: true)
        builder.call
      end

      it "builds setup script without Pry support" do
        builder.call

        expect(build_path.read).to eq(<<~'CONTENT')
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

      it "updates script permissions" do
        builder.call
        expect(build_path.stat.mode).to eq(33261)
      end
    end

    it "does not build setup script when disabled" do
      settings.merge! settings.minimize
      builder.call

      expect(build_path.exist?).to be(false)
    end
  end
end
