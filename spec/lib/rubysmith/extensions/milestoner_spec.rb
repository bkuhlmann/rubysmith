# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Extensions::Milestoner do
  subject(:extension) { described_class.new test_configuration, client: }

  include_context "with application dependencies"

  let(:client) { instance_spy Milestoner::Tags::Publisher }

  describe ".call" do
    it "answers configuration" do
      expect(described_class.call(configuration, client:)).to be_a(Rubysmith::Configuration::Model)
    end
  end

  describe "#call" do
    let(:test_configuration) { configuration.minimize }

    it "messages client" do
      extension.call
      expect(client).to have_received(:call).with("0.0.0")
    end

    it "answers configuration" do
      expect(extension.call).to eq(test_configuration)
    end
  end
end
