# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Actions::IRBKit do
  subject(:action) { described_class.new input: }

  let(:input) { configuration.dup }

  include_context "with application dependencies"

  describe "#call" do
    it "answers nil without arguments" do
      action.call
      expect(input.build_irb_kit).to be(nil)
    end

    it "answers value when given agrument" do
      action.call true
      expect(input.build_irb_kit).to be(true)
    end
  end
end
