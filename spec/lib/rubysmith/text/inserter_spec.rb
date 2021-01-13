# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Text::Inserter do
  subject(:inserter) { described_class.new lines }

  let :lines do
    [
      "Curabitur eleifend",
      "wisi iaculis ipsum."
    ]
  end

  describe "#call" do
    it "inserts content before matched line" do
      inserter = described_class.new lines, :before

      expect(inserter.call("Test insert", /iaculis ipsum/)).to eq(
        [
          "Curabitur eleifend",
          "Test insert",
          "wisi iaculis ipsum."
        ]
      )
    end

    it "inserts content after matched line" do
      expect(inserter.call("Test insert", /iaculis ipsum/)).to eq(
        [
          "Curabitur eleifend",
          "wisi iaculis ipsum.",
          "Test insert"
        ]
      )
    end

    it "fails with invalid kind" do
      expectation = proc { described_class.new(lines, :bogus).call "Test", /iaculis/ }
      expect(&expectation).to raise_error(StandardError, /Unknown kind.+: bogus/)
    end

    it "doesn't mutate lines" do
      inserter.call("Test insert", /iaculis ipsum/)

      expect(lines).to eq(
        [
          "Curabitur eleifend",
          "wisi iaculis ipsum."
        ]
      )
    end

    it "answers original lines when line doesn't match pattern" do
      expect(inserter.call("Test insert", /no match/)).to eq(lines)
    end

    it "answers original lines when content is nil" do
      expect(inserter.call(nil, /no match/)).to eq(lines)
    end

    it "fails when pattern isn't a regular expression" do
      expectation = proc { inserter.call "Test.", nil }
      expect(&expectation).to raise_error(TypeError, /expected Regexp/)
    end
  end
end
