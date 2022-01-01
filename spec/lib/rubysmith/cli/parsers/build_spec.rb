# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Parsers::Build do
  subject(:parser) { described_class.new configuration.dup }

  include_context "with application container"

  it_behaves_like "a parser"

  describe "#call" do
    let(:empty_configuration) { Rubysmith::Configuration::Content.new }

    it "enables Amazing Print" do
      expect(parser.call(%w[--amazing_print])).to have_attributes(build_amazing_print: true)
    end

    it "disables Amazing Print" do
      expect(parser.call(%w[--no-amazing_print])).to have_attributes(build_amazing_print: false)
    end

    it "enables Bundler Leak" do
      expect(parser.call(%w[--bundler-leak])).to have_attributes(build_bundler_leak: true)
    end

    it "disables Bundler Leak" do
      expect(parser.call(%w[--no-bundler-leak])).to have_attributes(build_bundler_leak: false)
    end

    it "enables Circle CI" do
      expect(parser.call(%w[--circle_ci])).to have_attributes(build_circle_ci: true)
    end

    it "disables Circle CI" do
      expect(parser.call(%w[--no-circle_ci])).to have_attributes(build_circle_ci: false)
    end

    it "enables citation documentation" do
      expect(parser.call(%w[--citation])).to have_attributes(build_citation: true)
    end

    it "disables citation documentation" do
      expect(parser.call(%w[--no-citation])).to have_attributes(build_citation: false)
    end

    it "enables community documentation" do
      expect(parser.call(%w[--community])).to have_attributes(build_community: true)
    end

    it "disables community documentation" do
      expect(parser.call(%w[--no-community])).to have_attributes(build_community: false)
    end

    it "enables code of conduct documentation" do
      expect(parser.call(%w[--conduct])).to have_attributes(build_conduct: true)
    end

    it "disables code of conduct documentation" do
      expect(parser.call(%w[--no-conduct])).to have_attributes(build_conduct: false)
    end

    it "enables console" do
      expect(parser.call(%w[--console])).to have_attributes(build_console: true)
    end

    it "disables console" do
      expect(parser.call(%w[--no-console])).to have_attributes(build_console: false)
    end

    it "enables contributions" do
      expect(parser.call(%w[--contributions])).to have_attributes(build_contributions: true)
    end

    it "disables contributions" do
      expect(parser.call(%w[--no-contributions])).to have_attributes(build_contributions: false)
    end

    it "enables DeadEnd" do
      expect(parser.call(%w[--dead_end])).to have_attributes(build_dead_end: true)
    end

    it "disables DeadEnd" do
      expect(parser.call(%w[--no-dead_end])).to have_attributes(build_dead_end: false)
    end

    it "enables Debug" do
      expect(parser.call(%w[--debug])).to have_attributes(build_debug: true)
    end

    it "disables Debug" do
      expect(parser.call(%w[--no-debug])).to have_attributes(build_debug: false)
    end

    it "enables Git" do
      expect(parser.call(%w[--git])).to have_attributes(build_git: true)
    end

    it "disables Git" do
      expect(parser.call(%w[--no-git])).to have_attributes(build_git: false)
    end

    it "enables GitHub" do
      expect(parser.call(%w[--git_hub])).to have_attributes(build_git_hub: true)
    end

    it "disables GitHub" do
      expect(parser.call(%w[--no-git_hub])).to have_attributes(build_git_hub: false)
    end

    it "enables Git Lint" do
      expect(parser.call(%w[--git-lint])).to have_attributes(build_git_lint: true)
    end

    it "disables Git Lint" do
      expect(parser.call(%w[--no-git-lint])).to have_attributes(build_git_lint: false)
    end

    it "enables Guard" do
      expect(parser.call(%w[--guard])).to have_attributes(build_guard: true)
    end

    it "disables Guard" do
      expect(parser.call(%w[--no-guard])).to have_attributes(build_guard: false)
    end

    it "enables license documentation" do
      expect(parser.call(%w[--license])).to have_attributes(build_license: true)
    end

    it "disables license documentation" do
      expect(parser.call(%w[--no-license])).to have_attributes(build_license: false)
    end

    it "enables maximum option" do
      expect(parser.call(%w[--max])).to have_attributes(build_maximum: true)
    end

    it "enables maximum build options" do
      proof = configuration.maximize
                           .to_h
                           .select { |key, _value| key.start_with? "build_" }
                           .merge build_minimum: false

      expect(parser.call(%w[--max])).to have_attributes(proof)
    end

    it "enables minimum option" do
      expect(parser.call(%w[--min])).to have_attributes(build_minimum: true)
    end

    it "enables minimum build options" do
      proof = configuration.minimize
                           .to_h
                           .select { |key, _value| key.start_with? "build_" }
                           .merge build_maximum: false

      expect(parser.call(%w[--min])).to have_attributes(proof)
    end

    it "enables Rake" do
      expect(parser.call(%w[--rake])).to have_attributes(build_rake: true)
    end

    it "disables Rake" do
      expect(parser.call(%w[--no-rake])).to have_attributes(build_rake: false)
    end

    it "enables readme documentation" do
      expect(parser.call(%w[--readme])).to have_attributes(build_readme: true)
    end

    it "disables readme documentation" do
      expect(parser.call(%w[--no-readme])).to have_attributes(build_readme: false)
    end

    it "enables Reek" do
      expect(parser.call(%w[--reek])).to have_attributes(build_reek: true)
    end

    it "disables Reek" do
      expect(parser.call(%w[--no-reek])).to have_attributes(build_reek: false)
    end

    it "enables Refinements" do
      expect(parser.call(%w[--refinements])).to have_attributes(build_refinements: true)
    end

    it "disables Refinements" do
      expect(parser.call(%w[--no-refinements])).to have_attributes(build_refinements: false)
    end

    it "enables RSpec" do
      expect(parser.call(%w[--rspec])).to have_attributes(build_rspec: true)
    end

    it "disables RSpec" do
      expect(parser.call(%w[--no-rspec])).to have_attributes(build_rspec: false)
    end

    it "enables RuboCop" do
      expect(parser.call(%w[--rubocop])).to have_attributes(build_rubocop: true)
    end

    it "disables RuboCop" do
      expect(parser.call(%w[--no-rubocop])).to have_attributes(build_rubocop: false)
    end

    it "enables setup script" do
      expect(parser.call(%w[--setup])).to have_attributes(build_setup: true)
    end

    it "disables setup script" do
      expect(parser.call(%w[--no-setup])).to have_attributes(build_setup: false)
    end

    it "enables SimpleCov" do
      expect(parser.call(%w[--simple_cov])).to have_attributes(build_simple_cov: true)
    end

    it "disables SimpleCov" do
      expect(parser.call(%w[--no-simple_cov])).to have_attributes(build_simple_cov: false)
    end

    it "enables version history documentation" do
      expect(parser.call(%w[--versions])).to have_attributes(build_versions: true)
    end

    it "disables version history documentation" do
      expect(parser.call(%w[--no-versions])).to have_attributes(build_versions: false)
    end

    it "enables Zeitwerk" do
      expect(parser.call(%w[--zeitwerk])).to have_attributes(build_zeitwerk: true)
    end

    it "disables Zeitwerk" do
      expect(parser.call(%w[--no-zeitwerk])).to have_attributes(build_zeitwerk: false)
    end

    it "fails with invalid option" do
      expectation = proc { parser.call %w[--bogus] }
      expect(&expectation).to raise_error(OptionParser::InvalidOption, /--bogus/)
    end
  end
end
