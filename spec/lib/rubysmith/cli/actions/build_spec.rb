# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Actions::Build do
  subject(:action) { described_class.new builders: [builder] }

  include_context "with application container"

  let(:builder) { class_spy Rubysmith::Builders::Core }

  describe ".with_minimum" do
    it "answers procesor" do
      expect(described_class.with_minimum).to be_a(described_class)
    end
  end

  describe "#call" do
    it "calls builders" do
      action.call
      expect(builder).to have_received(:call).with(application_configuration)
    end
  end
end
