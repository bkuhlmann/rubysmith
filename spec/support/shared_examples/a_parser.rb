# frozen_string_literal: true

RSpec.shared_examples_for "a parser" do
  describe ".call" do
    it "answers empty array" do
      parser = described_class.call client: OptionParser.new
      expect(parser).to eq([])
    end
  end
end
