# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Core do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  using Refinements::Struct

  it_behaves_like "a builder"

  describe "#call" do
    context "with default configuration" do
      before do
        settings.merge! settings.minimize
        builder.call
      end

      it "builds project file" do
        expect(temp_dir.join("test", "lib", "test.rb").read).to eq(<<~CONTENT)
          # Main namespace.
          module Test
          end
        CONTENT
      end

      it "doesn't build specification" do
        expect(temp_dir.join("test/spec/lib/test_spec.rb").exist?).to be(false)
      end
    end

    context "with dashed project name" do
      before do
        settings.merge! settings.minimize.merge(project_name: "demo-test")
        builder.call
      end

      it "builds project file" do
        expect(temp_dir.join("demo-test", "lib", "demo", "test.rb").read).to eq(<<~CONTENT)
          module Demo
            # Main namespace.
            module Test
            end
          end
        CONTENT
      end

      it "doesn't build specification" do
        expect(temp_dir.join("test/spec/lib/test_spec.rb").exist?).to be(false)
      end
    end

    context "with default configuration and Zeitwerk enabled" do
      before do
        settings.merge! settings.minimize.merge(build_zeitwerk: true)
        builder.call
      end

      it "builds project file" do
        expect(temp_dir.join("test", "lib", "test.rb").read).to eq(<<~CONTENT)
          require "zeitwerk"

          Zeitwerk::Loader.new.then do |loader|
            loader.tag = File.basename __FILE__, ".rb"
            loader.push_dir __dir__
            loader.setup
          end

          # Main namespace.
          module Test
            def self.loader registry = Zeitwerk::Registry
                @loader ||= registry.loaders.find { |loader| loader.tag == File.basename(__FILE__, ".rb") }
          end

          end
        CONTENT
      end

      it "builds specification" do
        expect(temp_dir.join("test/spec/lib/test_spec.rb").read).to eq(<<~CONTENT)
          require "spec_helper"

          RSpec.describe Test do
            describe ".loader" do
              it "eager loads" do
                expectation = proc { described_class.loader.eager_load force: true }
                expect(&expectation).not_to raise_error
              end

              it "answers unique tag" do
                expect(described_class.loader.tag).to eq("test")
              end
            end
          end
        CONTENT
      end
    end

    context "with single dashed project name and Zeitwerk enabled" do
      before do
        settings.merge! settings.minimize.merge(project_name: "demo-test", build_zeitwerk: true)
        builder.call
      end

      it "builds project file" do
        expect(temp_dir.join("demo-test", "lib", "demo", "test.rb").read).to eq(<<~CONTENT)
          require "zeitwerk"

          Zeitwerk::Loader.new.then do |loader|
            loader.tag = "demo-test"
            loader.push_dir "\#{__dir__}/.."
            loader.setup
          end

          module Demo
            # Main namespace.
            module Test
              def self.loader registry = Zeitwerk::Registry
                  @loader ||= registry.loaders.find { |loader| loader.tag == "demo-test" }
            end

            end
          end
        CONTENT
      end

      it "builds specification" do
        expect(temp_dir.join("demo-test/spec/lib/demo/test_spec.rb").read).to eq(<<~CONTENT)
          require "spec_helper"

          RSpec.describe Demo::Test do
            describe ".loader" do
              it "eager loads" do
                expectation = proc { described_class.loader.eager_load force: true }
                expect(&expectation).not_to raise_error
              end

              it "answers unique tag" do
                expect(described_class.loader.tag).to eq("demo-test")
              end
            end
          end
        CONTENT
      end
    end

    context "with multi-dashed project name and Zeitwerk enabled" do
      before do
        settings.merge! settings.minimize.merge(
          project_name: "demo-test-example",
          build_zeitwerk: true
        )

        builder.call
      end

      it "builds project file" do
        expect(temp_dir.join("demo-test-example/lib/demo/test/example.rb").read).to eq(<<~CONTENT)
          require "zeitwerk"

          Zeitwerk::Loader.new.then do |loader|
            loader.tag = "demo-test-example"
            loader.push_dir "\#{__dir__}/../.."
            loader.setup
          end

          module Demo
            module Test
              # Main namespace.
              module Example
                def self.loader registry = Zeitwerk::Registry
                    @loader ||= registry.loaders.find { |loader| loader.tag == "demo-test-example" }
              end

          end
            end
          end
        CONTENT
      end

      it "builds specification" do
        contents = temp_dir.join("demo-test-example/spec/lib/demo/test/example_spec.rb").read

        expect(contents).to eq(<<~CONTENT)
          require "spec_helper"

          RSpec.describe Demo::Test::Example do
            describe ".loader" do
              it "eager loads" do
                expectation = proc { described_class.loader.eager_load force: true }
                expect(&expectation).not_to raise_error
              end

              it "answers unique tag" do
                expect(described_class.loader.tag).to eq("demo-test-example")
              end
            end
          end
        CONTENT
      end
    end
  end
end
