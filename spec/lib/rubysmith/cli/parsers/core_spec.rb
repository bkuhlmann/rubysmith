# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Parsers::Core do
  subject(:parser) { described_class.new application_configuration.dup }

  include_context "with application container"

  it_behaves_like "a parser"

  describe "#call" do
    it "answers config edit (short)" do
      expect(parser.call(%w[-c edit])).to have_attributes(action_config: :edit)
    end

    it "answers config edit (long)" do
      expect(parser.call(%w[--config edit])).to have_attributes(action_config: :edit)
    end

    it "answers config view (short)" do
      expect(parser.call(%w[-c view])).to have_attributes(action_config: :view)
    end

    it "answers config view (long)" do
      expect(parser.call(%w[--config view])).to have_attributes(action_config: :view)
    end

    it "fails with missing config action" do
      expectation = proc { parser.call %w[--config] }
      expect(&expectation).to raise_error(OptionParser::MissingArgument, /--config/)
    end

    it "fails with invalid config action" do
      expectation = proc { parser.call %w[--config bogus] }
      expect(&expectation).to raise_error(OptionParser::InvalidArgument, /bogus/)
    end

    it "answers build (short)" do
      expect(parser.call(%w[-b test])).to have_attributes(action_build: true)
    end

    it "answers build (long)" do
      expect(parser.call(%w[--build test])).to have_attributes(action_build: true)
    end

    it "answers project name (short)" do
      expect(parser.call(%w[-b test])).to have_attributes(project_name: "test")
    end

    it "answers project name (long)" do
      expect(parser.call(%w[--build test])).to have_attributes(project_name: "test")
    end

    it "fails with missing build name" do
      expectation = proc { parser.call %w[--build] }
      expect(&expectation).to raise_error(OptionParser::MissingArgument, /--build/)
    end

    it "answers version (short)" do
      expect(parser.call(%w[-v])).to have_attributes(action_version: true)
    end

    it "answers version (long)" do
      expect(parser.call(%w[--version])).to have_attributes(action_version: true)
    end

    it "enables help (short)" do
      expect(parser.call(%w[-h])).to have_attributes(action_help: true)
    end

    it "enables help (long)" do
      expect(parser.call(%w[--help])).to have_attributes(action_help: true)
    end
  end
end
