# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Transformers::CurrentTime do
  include Dry::Monads[:result]

  subject(:transformer) { described_class }

  describe "#call" do
    let(:at) { Time.now }

    it "answers custom time when key is present" do
      expect(transformer.call({now: at})).to eq(Success(now: at))
    end

    it "answers custom time when attributes are empty" do
      expect(transformer.call({}, at:)).to eq(Success(now: at))
    end

    it "answers default time without attributes or custom time" do
      expect(transformer.call({}).success).to match(now: kind_of(Time))
    end
  end
end
