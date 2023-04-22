# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Enhancers::CurrentTime do
  subject(:enhancer) { described_class }

  describe "#call" do
    let(:content) { Rubysmith::Configuration::Model.new }
    let(:at) { Time.now }

    it "answers current time" do
      expect(enhancer.call(content, at:)).to have_attributes(now: at)
    end
  end
end
