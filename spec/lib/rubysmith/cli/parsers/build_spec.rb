# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Parsers::Build do
  subject(:parser) { described_class.new options: options }

  let(:options) { {} }

  it_behaves_like "a parser"

  describe "#call" do
    it "enables bundler audit" do
      parser.call %w[--bundler-audit]
      expect(options).to eq(build_bundler_audit: true)
    end

    it "disables bundler audit" do
      parser.call %w[--no-bundler-audit]
      expect(options).to eq(build_bundler_audit: false)
    end

    it "enables console" do
      parser.call %w[--console]
      expect(options).to eq(build_console: true)
    end

    it "disables console" do
      parser.call %w[--no-console]
      expect(options).to eq(build_console: false)
    end

    it "enables documentation" do
      parser.call %w[--documentation]
      expect(options).to eq(build_documentation: true)
    end

    it "disables documentation" do
      parser.call %w[--no-documentation]
      expect(options).to eq(build_documentation: false)
    end

    it "enables Git" do
      parser.call %w[--git]
      expect(options).to eq(build_git: true)
    end

    it "disables Git" do
      parser.call %w[--no-git]
      expect(options).to eq(build_git: false)
    end

    it "enables Git Lint" do
      parser.call %w[--git-lint]
      expect(options).to eq(build_git_lint: true)
    end

    it "disables Git Lint" do
      parser.call %w[--no-git-lint]
      expect(options).to eq(build_git_lint: false)
    end

    it "enables guard" do
      parser.call %w[--guard]
      expect(options).to eq(build_guard: true)
    end

    it "disables guard" do
      parser.call %w[--no-guard]
      expect(options).to eq(build_guard: false)
    end

    it "enables setup" do
      parser.call %w[--setup]
      expect(options).to eq(build_setup: true)
    end

    it "disables setup" do
      parser.call %w[--no-setup]
      expect(options).to eq(build_setup: false)
    end

    it "enables pry" do
      parser.call %w[--pry]
      expect(options).to eq(build_pry: true)
    end

    it "disables pry" do
      parser.call %w[--no-pry]
      expect(options).to eq(build_pry: false)
    end

    it "enables reek" do
      parser.call %w[--reek]
      expect(options).to eq(build_reek: true)
    end

    it "disables reek" do
      parser.call %w[--no-reek]
      expect(options).to eq(build_reek: false)
    end

    it "enables RSpec" do
      parser.call %w[--rspec]
      expect(options).to eq(build_rspec: true)
    end

    it "disables RSpec" do
      parser.call %w[--no-rspec]
      expect(options).to eq(build_rspec: false)
    end

    it "enables Rubocop" do
      parser.call %w[--rubocop]
      expect(options).to eq(build_rubocop: true)
    end

    it "disables Rubocop" do
      parser.call %w[--no-rubocop]
      expect(options).to eq(build_rubocop: false)
    end

    it "enables SimpleCov" do
      parser.call %w[--simple_cov]
      expect(options).to eq(build_simple_cov: true)
    end

    it "disables SimpleCov" do
      parser.call %w[--no-simple_cov]
      expect(options).to eq(build_simple_cov: false)
    end

    it "fails with invalid option" do
      expectation = proc { parser.call %w[--bogus] }
      expect(&expectation).to raise_error(OptionParser::InvalidOption, /--bogus/)
    end
  end
end
