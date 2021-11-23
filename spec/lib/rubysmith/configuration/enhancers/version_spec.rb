# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Enhancers::Version do
  subject(:enhancer) { described_class.new version }

  let(:version) { "1.2.3" }

  describe "#call" do
    let(:content) { Rubysmith::Configuration::Content.new }

    it "answers version" do
      expect(enhancer.call(content)).to have_attributes(version: "1.2.3")
    end
  end
end
