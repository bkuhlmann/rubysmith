# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Configuration::Enhancers::CurrentTime do
  subject(:enhancer) { described_class.new now }

  let(:now) { Time.now }
  let(:content) { Rubysmith::CLI::Configuration::Content.new }

  describe "#call" do
    it "answers current time" do
      expect(enhancer.call(content)).to have_attributes(now: now)
    end
  end
end
