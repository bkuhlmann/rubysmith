# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Actions::AmazingPrint do
  subject(:action) { described_class.new inputs: }

  let(:inputs) { configuration.dup }

  include_context "with application dependencies"

  describe "#call" do
    it "answers true by default" do
      action.call
      expect(inputs.build_amazing_print).to be(true)
    end

    it "answers false when given false" do
      action.call false
      expect(inputs.build_amazing_print).to be(false)
    end
  end
end
