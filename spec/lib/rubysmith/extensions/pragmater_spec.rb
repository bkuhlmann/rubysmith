# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Extensions::Pragmater do
  subject(:extension) { described_class.new configuration, client: }

  include_context "with application dependencies"

  let(:client) { instance_spy Pragmater::Inserter }

  describe ".call" do
    it "answers configuration" do
      expect(described_class.call(configuration, client:)).to be_a(Rubysmith::Configuration::Model)
    end
  end

  describe "#call" do
    before { extension.call }

    it "delegates to client" do
      expect(client).to have_received(:call)
    end

    it "answers configuration" do
      expect(extension.call).to eq(configuration)
    end
  end
end
