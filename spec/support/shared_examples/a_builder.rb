# frozen_string_literal: true

RSpec.shared_examples_for "a builder" do
  describe ".call" do
    it "calls builder" do
      expect(described_class.call(default_configuration)).to eq(nil)
    end
  end
end
