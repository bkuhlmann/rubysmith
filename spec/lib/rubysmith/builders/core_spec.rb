# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Core do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  using Refinements::Structs

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "with default configuration" do
      let(:test_configuration) { configuration.minimize }

      it "builds project file" do
        expect(temp_dir.join("test", "lib", "test.rb").read).to eq(<<~CONTENT)
          # Main namespace.
          module Test
          end
        CONTENT
      end
    end

    context "with dashed project name" do
      let(:test_configuration) { configuration.minimize.merge project_name: "demo-test" }

      it "builds project file" do
        expect(temp_dir.join("demo-test", "lib", "demo", "test.rb").read).to eq(<<~CONTENT)
          module Demo
            # Main namespace.
            module Test
            end
          end
        CONTENT
      end
    end

    context "with default configuration and Zeitwerk enabled" do
      let(:test_configuration) { configuration.minimize.merge build_zeitwerk: true }

      it "builds project file" do
        expect(temp_dir.join("test", "lib", "test.rb").read).to eq(<<~CONTENT)
          require "zeitwerk"

          Zeitwerk::Loader.for_gem.setup

          # Main namespace.
          module Test
          end
        CONTENT
      end
    end

    context "with single dashed project name and Zeitwerk enabled" do
      let :test_configuration do
        configuration.minimize.merge project_name: "demo-test", build_zeitwerk: true
      end

      it "builds project file" do
        expect(temp_dir.join("demo-test", "lib", "demo", "test.rb").read).to eq(<<~CONTENT)
          require "zeitwerk"

          Zeitwerk::Loader.new.then do |loader|
            loader.push_dir "\#{__dir__}/.."
            loader.setup
          end

          module Demo
            # Main namespace.
            module Test
            end
          end
        CONTENT
      end
    end

    context "with multi-dashed project name and Zeitwerk enabled" do
      let :test_configuration do
        configuration.minimize.merge project_name: "demo-test-example", build_zeitwerk: true
      end

      it "builds project file" do
        expect(temp_dir.join("demo-test-example/lib/demo/test/example.rb").read).to eq(<<~CONTENT)
          require "zeitwerk"

          Zeitwerk::Loader.new.then do |loader|
            loader.push_dir "\#{__dir__}/../.."
            loader.setup
          end

          module Demo
            module Test
              # Main namespace.
              module Example
              end
            end
          end
        CONTENT
      end
    end
  end
end
