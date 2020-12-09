# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::RSpec::Helper, :realm do
  subject(:builder) { described_class.new realm }

  let(:spec_helper_path) { temp_dir.join "test", "spec", "spec_helper.rb" }

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled with no options" do
      let(:realm) { default_realm.with build_rspec: true }

      let :proof do
        <<~BODY
          require "bundler/setup"
          Bundler.require :tools

          require "test"

          Dir[File.join(__dir__, "support", "shared_contexts", "**/*.rb")].sort.each { |path| require path }

          RSpec.configure do |config|
            config.color = true
            config.disable_monkey_patching!
            config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
            config.filter_run_when_matching :focus
            config.formatter = ENV["CI"] == "true" ? :progress : :documentation
            config.order = :random
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
          end
        BODY
      end

      it "builds spec helper" do
        expect(spec_helper_path.read).to eq(proof)
      end
    end

    context "when enabled with SimpleCov only" do
      let(:realm) { default_realm.with build_rspec: true, build_simple_cov: true }

      let :proof do
        <<~BODY
          require "bundler/setup"
          Bundler.require :tools

          require "simplecov"
          SimpleCov.start { enable_coverage :branch }

          require "test"

          Dir[File.join(__dir__, "support", "shared_contexts", "**/*.rb")].sort.each { |path| require path }

          RSpec.configure do |config|
            config.color = true
            config.disable_monkey_patching!
            config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
            config.filter_run_when_matching :focus
            config.formatter = ENV["CI"] == "true" ? :progress : :documentation
            config.order = :random
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
          end
        BODY
      end

      it "builds spec helper" do
        expect(spec_helper_path.read).to eq(proof)
      end
    end

    context "when enabled with Pry only" do
      let(:realm) { default_realm.with build_rspec: true, build_pry: true }

      let :proof do
        <<~BODY
          require "bundler/setup"
          Bundler.require :tools

          require "test"

          Dir[File.join(__dir__, "support", "shared_contexts", "**/*.rb")].sort.each { |path| require path }

          RSpec.configure do |config|
            config.color = true
            config.disable_monkey_patching!
            config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
            config.filter_run_when_matching :focus
            config.formatter = ENV["CI"] == "true" ? :progress : :documentation
            config.order = :random
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
          end
        BODY
      end

      it "builds spec helper" do
        expect(spec_helper_path.read).to eq(proof)
      end
    end

    context "when enabled with all options and no refinements" do
      let(:realm) { default_realm.with build_rspec: true, build_simple_cov: true, build_pry: true }

      let :proof do
        <<~BODY
          require "bundler/setup"
          Bundler.require :tools

          require "simplecov"
          SimpleCov.start { enable_coverage :branch }

          require "test"

          Dir[File.join(__dir__, "support", "shared_contexts", "**/*.rb")].sort.each { |path| require path }

          RSpec.configure do |config|
            config.color = true
            config.disable_monkey_patching!
            config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
            config.filter_run_when_matching :focus
            config.formatter = ENV["CI"] == "true" ? :progress : :documentation
            config.order = :random
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
          end
        BODY
      end

      it "builds spec helper" do
        expect(spec_helper_path.read).to eq(proof)
      end
    end

    context "when enabled with all options and refinements" do
      let :realm do
        default_realm.with build_rspec: true,
                           build_refinements: true,
                           build_simple_cov: true,
                           build_pry: true
      end

      let :proof do
        <<~BODY
          require "bundler/setup"
          Bundler.require :tools

          require "simplecov"
          SimpleCov.start { enable_coverage :branch }

          require "test"
          require "refinements"

          using Refinements::Pathnames

          Pathname.require_tree __dir__, "support/shared_contexts/**/*.rb"

          RSpec.configure do |config|
            config.color = true
            config.disable_monkey_patching!
            config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
            config.filter_run_when_matching :focus
            config.formatter = ENV["CI"] == "true" ? :progress : :documentation
            config.order = :random
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
          end
        BODY
      end

      it "builds spec helper" do
        expect(spec_helper_path.read).to eq(proof)
      end
    end

    context "when disabled" do
      let(:realm) { default_realm.with build_rspec: false }

      it "doesn't build spec helper" do
        expect(spec_helper_path.exist?).to eq(false)
      end
    end
  end
end
