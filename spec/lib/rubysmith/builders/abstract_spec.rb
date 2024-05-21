# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Abstract do
  subject(:builder) { described_class.new configuration }

  include_context "with application dependencies"

  describe "#call" do
    it "fails when not implemented" do
      expectation = proc { builder.call }
      expect(&expectation).to raise_error(NoMethodError, /must be implemented/)
    end
  end
end
