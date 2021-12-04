# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Extensions::Milestoner do
  using Refinements::Pathnames

  subject(:extension) { described_class.new test_configuration, client: }

  include_context "with application container"

  let(:client) { instance_spy Milestoner::Tags::Publisher }

  describe ".call" do
    it "answers configuration" do
      expect(described_class.call("0.0.0", configuration, client:)).to be_a(
        Rubysmith::Configuration::Content
      )
    end
  end

  describe "#call" do
    before { extension.call "0.0.0" }

    context "with default configuration" do
      let(:test_configuration) { configuration.minimize }

      it "messages client" do
        expect(client).to have_received(:call).with(
          Milestoner::Configuration::Content[
            documentation_format: "md",
            prefixes: %w[Fixed Added Updated Removed Refactored],
            sign: false,
            version: "0.0.0"
          ]
        )
      end
    end

    context "with custom configuration" do
      let :test_configuration do
        configuration.with extensions_milestoner_documentation_format: "adoc",
                           extensions_milestoner_prefixes: %w[Added],
                           extensions_milestoner_sign: true
      end

      it "messages client" do
        expect(client).to have_received(:call).with(
          Milestoner::Configuration::Content[
            documentation_format: "adoc",
            prefixes: %w[Added],
            sign: true,
            version: "0.0.0"
          ]
        )
      end
    end
  end
end
