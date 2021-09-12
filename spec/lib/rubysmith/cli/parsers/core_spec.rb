# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Parsers::Core do
  subject(:parser) { described_class.new }

  include_context "with application container"

  it_behaves_like "a parser"

  describe "#call" do
    it "answers config edit (short)" do
      parser.call %w[-c edit]
      expect(application_configuration.config).to eq(:edit)
    end

    it "answers config edit (long)" do
      parser.call %w[--config edit]
      expect(application_configuration.config).to eq(:edit)
    end

    it "answers config view (short)" do
      parser.call %w[-c view]
      expect(application_configuration.config).to eq(:view)
    end

    it "answers config view (long)" do
      parser.call %w[--config view]
      expect(application_configuration.config).to eq(:view)
    end

    it "fails with missing config action" do
      expectation = proc { parser.call %w[--config] }
      expect(&expectation).to raise_error(OptionParser::MissingArgument, /--config/)
    end

    it "fails with invalid config action" do
      expectation = proc { parser.call %w[--config bogus] }
      expect(&expectation).to raise_error(OptionParser::InvalidArgument, /bogus/)
    end

    it "answers build any project (short)" do
      parser.call %w[-b test]
      expect(application_configuration.build_any).to eq(true)
    end

    it "answers build any project (long)" do
      parser.call %w[--build test]
      expect(application_configuration.build_any).to eq(true)
    end

    it "answers build project name (short)" do
      parser.call %w[-b test]
      expect(application_configuration.project_name).to eq("test")
    end

    it "answers build project name (long)" do
      parser.call %w[--build test]
      expect(application_configuration.project_name).to eq("test")
    end

    it "fails with missing build name" do
      expectation = proc { parser.call %w[--build] }
      expect(&expectation).to raise_error(OptionParser::MissingArgument, /--build/)
    end

    it "answers version (short)" do
      parser.call %w[-v]
      expect(application_configuration.version).to match_cli_version
    end

    it "answers version (long)" do
      parser.call %w[--version]
      expect(application_configuration.version).to match_cli_version
    end

    it "enables help (short)" do
      parser.call %w[-h]
      expect(application_configuration.help).to eq(true)
    end

    it "enables help (long)" do
      parser.call %w[--help]
      expect(application_configuration.help).to eq(true)
    end
  end
end
