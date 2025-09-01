# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::RSpec::Helper do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  let(:path) { temp_dir.join "test/spec/spec_helper.rb" }

  describe "#call" do
    context "when enabled with no options" do
      let :proof do
        <<~BODY
          Bundler.require :tools

          require "test"

          SPEC_ROOT = Pathname(__dir__).realpath.freeze

          Dir[File.join(SPEC_ROOT, "support", "shared_contexts", "**/*.rb")].each { |path| require path }

          RSpec.configure do |config|
            config.color = true
            config.disable_monkey_patching!
            config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
            config.filter_run_when_matching :focus
            config.formatter = ENV.fetch("CI", false) == "true" ? :progress : :documentation
            config.order = :random
            config.pending_failure_output = :no_backtrace
            config.shared_context_metadata_behavior = :apply_to_host_groups
            config.warnings = true

            config.expect_with :rspec do |expectations|
              expectations.syntax = :expect
              expectations.include_chain_clauses_in_custom_matcher_descriptions = true
            end

            config.mock_with :rspec do |mocks|
              mocks.verify_doubled_constant_names = true
              mocks.verify_partial_doubles = true
            end


            Kernel.srand config.seed
          end
        BODY
      end

      before { settings.with! settings.minimize.with(build_rspec: true) }

      it "builds file" do
        builder.call
        expect(path.read).to eq(proof)
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when enabled with dashed project name" do
      let :proof do
        <<~BODY
          Bundler.require :tools

          require "demo/test"

          SPEC_ROOT = Pathname(__dir__).realpath.freeze

          Dir[File.join(SPEC_ROOT, "support", "shared_contexts", "**/*.rb")].each { |path| require path }

          RSpec.configure do |config|
            config.color = true
            config.disable_monkey_patching!
            config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
            config.filter_run_when_matching :focus
            config.formatter = ENV.fetch("CI", false) == "true" ? :progress : :documentation
            config.order = :random
            config.pending_failure_output = :no_backtrace
            config.shared_context_metadata_behavior = :apply_to_host_groups
            config.warnings = true

            config.expect_with :rspec do |expectations|
              expectations.syntax = :expect
              expectations.include_chain_clauses_in_custom_matcher_descriptions = true
            end

            config.mock_with :rspec do |mocks|
              mocks.verify_doubled_constant_names = true
              mocks.verify_partial_doubles = true
            end


            Kernel.srand config.seed
          end
        BODY
      end

      before do
        settings.with! settings.minimize.with(project_name: "demo-test", build_rspec: true)
      end

      it "builds file" do
        builder.call
        expect(temp_dir.join("demo-test/spec/spec_helper.rb").read).to eq(proof)
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when enabled with Monads only" do
      let :proof do
        <<~BODY
          Bundler.require :tools

          require "test"
          require "dry/monads"

          SPEC_ROOT = Pathname(__dir__).realpath.freeze

          Dir[File.join(SPEC_ROOT, "support", "shared_contexts", "**/*.rb")].each { |path| require path }

          RSpec.configure do |config|
            config.color = true
            config.disable_monkey_patching!
            config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
            config.filter_run_when_matching :focus
            config.formatter = ENV.fetch("CI", false) == "true" ? :progress : :documentation
            config.order = :random
            config.pending_failure_output = :no_backtrace
            config.shared_context_metadata_behavior = :apply_to_host_groups
            config.warnings = true

            config.expect_with :rspec do |expectations|
              expectations.syntax = :expect
              expectations.include_chain_clauses_in_custom_matcher_descriptions = true
            end

            config.mock_with :rspec do |mocks|
              mocks.verify_doubled_constant_names = true
              mocks.verify_partial_doubles = true
            end

            config.before(:suite) { Dry::Monads.load_extensions :rspec }

            Kernel.srand config.seed
          end
        BODY
      end

      before { settings.with! settings.minimize.with(build_rspec: true, build_monads: true) }

      it "builds file" do
        builder.call
        expect(path.read).to eq(proof)
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when enabled with Refinements only" do
      let :proof do
        <<~BODY
          Bundler.require :tools

          require "test"
          require "refinements"

          SPEC_ROOT = Pathname(__dir__).realpath.freeze

          using Refinements::Pathname

          Pathname.require_tree SPEC_ROOT.join("support/shared_contexts")

          RSpec.configure do |config|
            config.color = true
            config.disable_monkey_patching!
            config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
            config.filter_run_when_matching :focus
            config.formatter = ENV.fetch("CI", false) == "true" ? :progress : :documentation
            config.order = :random
            config.pending_failure_output = :no_backtrace
            config.shared_context_metadata_behavior = :apply_to_host_groups
            config.warnings = true

            config.expect_with :rspec do |expectations|
              expectations.syntax = :expect
              expectations.include_chain_clauses_in_custom_matcher_descriptions = true
            end

            config.mock_with :rspec do |mocks|
              mocks.verify_doubled_constant_names = true
              mocks.verify_partial_doubles = true
            end


            Kernel.srand config.seed
          end
        BODY
      end

      before do
        settings.with! settings.minimize.with(build_rspec: true, build_refinements: true)
      end

      it "builds file" do
        builder.call
        expect(path.read).to eq(proof)
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when enabled with SimpleCov only" do
      let :proof do
        <<~BODY
          require "simplecov"

          if ENV["COVERAGE"] == "no"
            puts "SimpleCov skipped due to being disabled."
          else
            SimpleCov.start do
              add_filter %r(^/spec/)
              enable_coverage :branch
              enable_coverage_for_eval
              minimum_coverage_by_file line: 95, branch: 95
            end
          end

          Bundler.require :tools

          require "test"

          SPEC_ROOT = Pathname(__dir__).realpath.freeze

          Dir[File.join(SPEC_ROOT, "support", "shared_contexts", "**/*.rb")].each { |path| require path }

          RSpec.configure do |config|
            config.color = true
            config.disable_monkey_patching!
            config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
            config.filter_run_when_matching :focus
            config.formatter = ENV.fetch("CI", false) == "true" ? :progress : :documentation
            config.order = :random
            config.pending_failure_output = :no_backtrace
            config.shared_context_metadata_behavior = :apply_to_host_groups
            config.warnings = true

            config.expect_with :rspec do |expectations|
              expectations.syntax = :expect
              expectations.include_chain_clauses_in_custom_matcher_descriptions = true
            end

            config.mock_with :rspec do |mocks|
              mocks.verify_doubled_constant_names = true
              mocks.verify_partial_doubles = true
            end


            Kernel.srand config.seed
          end
        BODY
      end

      before { settings.with! settings.minimize.with(build_rspec: true, build_simple_cov: true) }

      it "builds file" do
        builder.call
        expect(path.read).to eq(proof)
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when enabled with all options" do
      let :proof do
        <<~BODY
          require "simplecov"

          if ENV["COVERAGE"] == "no"
            puts "SimpleCov skipped due to being disabled."
          else
            SimpleCov.start do
              add_filter %r(^/spec/)
              enable_coverage :branch
              enable_coverage_for_eval
              minimum_coverage_by_file line: 95, branch: 95
            end
          end

          Bundler.require :tools

          require "test"
          require "dry/monads"
          require "refinements"

          SPEC_ROOT = Pathname(__dir__).realpath.freeze

          using Refinements::Pathname

          Pathname.require_tree SPEC_ROOT.join("support/shared_contexts")

          RSpec.configure do |config|
            config.color = true
            config.disable_monkey_patching!
            config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
            config.filter_run_when_matching :focus
            config.formatter = ENV.fetch("CI", false) == "true" ? :progress : :documentation
            config.order = :random
            config.pending_failure_output = :no_backtrace
            config.shared_context_metadata_behavior = :apply_to_host_groups
            config.warnings = true

            config.expect_with :rspec do |expectations|
              expectations.syntax = :expect
              expectations.include_chain_clauses_in_custom_matcher_descriptions = true
            end

            config.mock_with :rspec do |mocks|
              mocks.verify_doubled_constant_names = true
              mocks.verify_partial_doubles = true
            end

            config.before(:suite) { Dry::Monads.load_extensions :rspec }

            Kernel.srand config.seed
          end
        BODY
      end

      before { settings.with! settings.maximize }

      it "builds file" do
        builder.call
        expect(path.read).to eq(proof)
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.with! settings.minimize }

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
