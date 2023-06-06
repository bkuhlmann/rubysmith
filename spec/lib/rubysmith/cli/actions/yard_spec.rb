# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Actions::Yard do
  subject(:action) { described_class.new inputs: }

  let(:inputs) { configuration.dup }

  include_context "with application dependencies"

  describe "#call" do
    it "answers false by default" do
      action.call
      expect(inputs.build_yard).to be(false)
    end

    it "answers true when given true" do
      action.call true
      expect(inputs.build_yard).to be(true)
    end
  end
end
