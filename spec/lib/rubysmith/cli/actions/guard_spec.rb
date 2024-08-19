# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Actions::Guard do
  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers true when true" do
      action.call true
      expect(settings.build_guard).to be(true)
    end

    it "answers false when false" do
      action.call false
      expect(settings.build_guard).to be(false)
    end
  end
end
