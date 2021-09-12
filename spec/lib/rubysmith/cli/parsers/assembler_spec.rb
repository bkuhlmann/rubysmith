# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Parsers::Assembler do
  subject(:parser) { described_class.new }

  include_context "with application container"

  describe "#call" do
    it "answers hash with valid option" do
      expect(parser.call(%w[--help])).to have_attributes(help: true)
    end

    it "fails with invalid option" do
      expectation = proc { parser.call %w[--bogus] }
      expect(&expectation).to raise_error(OptionParser::InvalidOption, /--bogus/)
    end
  end

  describe "#to_s" do
    it "answers usage" do
      parser.call
      expect(parser.to_s).to match(/.+USAGE.+BUILD\sOPTIONS.+/m)
    end
  end
end
