# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Actions::Publish do
  using Refinements::Struct

  subject(:action) { described_class.new extension: }

  include_context "with application dependencies"

  let(:extension) { class_spy Rubysmith::Extensions::Milestoner }

  describe "#call" do
    it "messages extension" do
      action.call "0.0.0"
      expect(extension).to have_received(:call).with(configuration.merge(project_version: "0.0.0"))
    end
  end
end
