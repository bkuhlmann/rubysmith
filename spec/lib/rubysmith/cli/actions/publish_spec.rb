# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Actions::Publish do
  subject(:action) { described_class.new extension: }

  include_context "with application container"

  let(:extension) { class_spy Rubysmith::Extensions::Milestoner }

  describe "#call" do
    it "messages extension" do
      action.call configuration
      expect(extension).to have_received(:call).with(configuration)
    end
  end
end
