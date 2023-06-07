# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Actions::GitHub do
  subject(:action) { described_class.new input: }

  let(:input) { configuration.dup }

  include_context "with application dependencies"

  describe "#call" do
    it "answers false by default" do
      action.call
      expect(input.build_git_hub).to be(false)
    end

    it "answers true when given true" do
      action.call true
      expect(input.build_git_hub).to be(true)
    end
  end
end
