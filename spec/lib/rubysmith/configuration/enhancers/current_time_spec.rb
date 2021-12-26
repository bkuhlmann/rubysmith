# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Enhancers::CurrentTime do
  subject(:enhancer) { described_class.new now }

  let(:now) { Time.now }

  describe "#call" do
    let(:content) { Rubysmith::Configuration::Content.new }

    it "answers current time" do
      expect(enhancer.call(content)).to have_attributes(now:)
    end
  end
end
