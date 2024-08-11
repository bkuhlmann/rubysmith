# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Actions::Funding do
  subject(:action) { described_class.new }

  let(:settings) { settings.dup }

  include_context "with application dependencies"

  describe "#call" do
    it "answers true when true" do
      action.call true
      expect(settings.build_funding).to be(true)
    end

    it "answers false when false" do
      action.call false
      expect(settings.build_funding).to be(false)
    end
  end
end
