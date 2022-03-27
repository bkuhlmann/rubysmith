# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Actions::Build do
  subject(:action) { described_class.new builders: [builder] }

  include_context "with application dependencies"

  let(:builder) { class_spy Rubysmith::Builders::Core }

  describe "#call" do
    it "calls builders" do
      action.call configuration
      expect(builder).to have_received(:call).with(configuration)
    end
  end
end
