# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Actions::Name do
  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "sets project name" do
      action.call "test"
      expect(settings.project_name).to eq("test")
    end
  end
end
