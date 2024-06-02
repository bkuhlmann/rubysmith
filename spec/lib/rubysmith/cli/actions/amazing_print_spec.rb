# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Actions::AmazingPrint do
  subject(:action) { described_class.new }

  let(:settings) { settings.dup }

  include_context "with application dependencies"

  describe "#call" do
    it "answers nil without arguments" do
      action.call
      expect(settings.build_amazing_print).to be(nil)
    end

    it "answers value when given agrument" do
      action.call true
      expect(settings.build_amazing_print).to be(true)
    end
  end
end
