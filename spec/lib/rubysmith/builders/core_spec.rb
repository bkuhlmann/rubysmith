# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Core do
  subject(:builder) { described_class.new configuration }

  include_context "with configuration"

  using Refinements::Structs

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "with default configuration" do
      let(:configuration) { default_configuration }

      it "builds project file" do
        expect(temp_dir.join("test", "lib", "test.rb").read).to eq(<<~CONTENT)
          # Main namespace.
          module Test
          end
        CONTENT
      end

      it "builds Ruby version file" do
        expect(temp_dir.join("test", ".ruby-version").read).to eq(RUBY_VERSION)
      end
    end

    context "with dashed project name" do
      let(:configuration) { default_configuration.merge project_name: "demo-test" }

      it "builds project file" do
        expect(temp_dir.join("demo-test", "lib", "demo", "test.rb").read).to eq(<<~CONTENT)
          # Main namespace.
          module Demo
            module Test
            end
          end
        CONTENT
      end

      it "builds Ruby version file" do
        expect(temp_dir.join("demo-test", ".ruby-version").read).to eq(RUBY_VERSION)
      end
    end

    context "with Zeitwerk enabled" do
      let(:configuration) { default_configuration.with build_zeitwerk: true }

      it "builds project file" do
        expect(temp_dir.join("test", "lib", "test.rb").read).to eq(<<~CONTENT)
          require "zeitwerk"

          loader = Zeitwerk::Loader.for_gem
          loader.setup

          # Main namespace.
          module Test
          end
        CONTENT
      end

      it "builds Ruby version file" do
        expect(temp_dir.join("test", ".ruby-version").read).to eq(RUBY_VERSION)
      end
    end
  end
end
