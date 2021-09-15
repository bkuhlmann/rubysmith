# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Parsers::Build do
  subject(:parser) { described_class.new }

  include_context "with application container"

  it_behaves_like "a parser"

  describe "#call" do
    it "enables Amazing Print" do
      parser.call %w[--amazing_print]
      expect(application_configuration.build_amazing_print).to eq(true)
    end

    it "disables Amazing Print" do
      parser.call %w[--no-amazing_print]
      expect(application_configuration.build_amazing_print).to eq(false)
    end

    it "enables Bundler Leak" do
      parser.call %w[--bundler-leak]
      expect(application_configuration.build_bundler_leak).to eq(true)
    end

    it "disables Bundler Leak" do
      parser.call %w[--no-bundler-leak]
      expect(application_configuration.build_bundler_leak).to eq(false)
    end

    it "enables console" do
      parser.call %w[--console]
      expect(application_configuration.build_console).to eq(true)
    end

    it "disables console" do
      parser.call %w[--no-console]
      expect(application_configuration.build_console).to eq(false)
    end

    it "enables Debug" do
      parser.call %w[--debug]
      expect(application_configuration.build_debug).to eq(true)
    end

    it "disables Debug" do
      parser.call %w[--no-debug]
      expect(application_configuration.build_debug).to eq(false)
    end

    it "enables documentation" do
      parser.call %w[--documentation]
      expect(application_configuration.build_documentation).to eq(true)
    end

    it "disables documentation" do
      parser.call %w[--no-documentation]
      expect(application_configuration.build_documentation).to eq(false)
    end

    it "enables Git" do
      parser.call %w[--git]
      expect(application_configuration.build_git).to eq(true)
    end

    it "disables Git" do
      parser.call %w[--no-git]
      expect(application_configuration.build_git).to eq(false)
    end

    it "enables Git Lint" do
      parser.call %w[--git-lint]
      expect(application_configuration.build_git_lint).to eq(true)
    end

    it "disables Git Lint" do
      parser.call %w[--no-git-lint]
      expect(application_configuration.build_git_lint).to eq(false)
    end

    it "enables Guard" do
      parser.call %w[--guard]
      expect(application_configuration.build_guard).to eq(true)
    end

    it "disables Guard" do
      parser.call %w[--no-guard]
      expect(application_configuration.build_guard).to eq(false)
    end

    it "enables minimum options" do
      parser.call %w[--min]
      expect(application_configuration.build_minimum).to eq(true)
    end

    it "enables pry" do
      parser.call %w[--pry]
      expect(application_configuration.build_pry).to eq(true)
    end

    it "disables pry" do
      parser.call %w[--no-pry]
      expect(application_configuration.build_pry).to eq(false)
    end

    it "enables Rake" do
      parser.call %w[--rake]
      expect(application_configuration.build_rake).to eq(true)
    end

    it "disables Rake" do
      parser.call %w[--no-rake]
      expect(application_configuration.build_rake).to eq(false)
    end

    it "enables Reek" do
      parser.call %w[--reek]
      expect(application_configuration.build_reek).to eq(true)
    end

    it "disables Reek" do
      parser.call %w[--no-reek]
      expect(application_configuration.build_reek).to eq(false)
    end

    it "enables Refinements" do
      parser.call %w[--refinements]
      expect(application_configuration.build_refinements).to eq(true)
    end

    it "disables Refinements" do
      parser.call %w[--no-refinements]
      expect(application_configuration.build_refinements).to eq(false)
    end

    it "enables RSpec" do
      parser.call %w[--rspec]
      expect(application_configuration.build_rspec).to eq(true)
    end

    it "disables RSpec" do
      parser.call %w[--no-rspec]
      expect(application_configuration.build_rspec).to eq(false)
    end

    it "enables Rubocop" do
      parser.call %w[--rubocop]
      expect(application_configuration.build_rubocop).to eq(true)
    end

    it "disables Rubocop" do
      parser.call %w[--no-rubocop]
      expect(application_configuration.build_rubocop).to eq(false)
    end

    it "enables setup" do
      parser.call %w[--setup]
      expect(application_configuration.build_setup).to eq(true)
    end

    it "disables setup" do
      parser.call %w[--no-setup]
      expect(application_configuration.build_setup).to eq(false)
    end

    it "enables SimpleCov" do
      parser.call %w[--simple_cov]
      expect(application_configuration.build_simple_cov).to eq(true)
    end

    it "disables SimpleCov" do
      parser.call %w[--no-simple_cov]
      expect(application_configuration.build_simple_cov).to eq(false)
    end

    it "enables Zeitwerk" do
      parser.call %w[--zeitwerk]
      expect(application_configuration.build_zeitwerk).to eq(true)
    end

    it "disables Zeitwerk" do
      parser.call %w[--no-zeitwerk]
      expect(application_configuration.build_zeitwerk).to eq(false)
    end

    it "fails with invalid option" do
      expectation = proc { parser.call %w[--bogus] }
      expect(&expectation).to raise_error(OptionParser::InvalidOption, /--bogus/)
    end
  end
end
