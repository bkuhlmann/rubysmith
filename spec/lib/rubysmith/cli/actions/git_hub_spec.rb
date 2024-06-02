# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Actions::GitHub do
  subject(:action) { described_class.new }

  let(:settings) { settings.dup }

  include_context "with application dependencies"

  describe "#call" do
    it "answers nil without arguments" do
      action.call
      expect(settings.build_git_hub).to be(nil)
    end

    it "answers value when given agrument" do
      action.call true
      expect(settings.build_git_hub).to be(true)
    end
  end
end
