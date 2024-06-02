# frozen_string_literal: true

RSpec.shared_examples "a builder" do
  describe ".call" do
    it "answers maximum configuration" do
      maximum = settings.maximize
      expect(described_class.call(settings: maximum)).to eq(maximum)
    end

    it "answers minimum configuration" do
      minimum = settings.minimize
      expect(described_class.call(settings: minimum)).to eq(minimum)
    end
  end
end
