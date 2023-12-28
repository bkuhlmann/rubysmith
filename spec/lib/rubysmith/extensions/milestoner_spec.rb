# frozen_string_literal: true

require "spec_helper"
require "versionaire"

RSpec.describe Rubysmith::Extensions::Milestoner do
  using Refinements::Pathname
  using Refinements::Struct
  using Versionaire::Cast

  subject(:extension) { described_class.new test_configuration, client: }

  include_context "with application dependencies"

  let(:client) { instance_spy Milestoner::Tags::Publisher }

  describe ".call" do
    it "answers configuration" do
      expect(described_class.call(configuration, client:)).to be_a(
        Rubysmith::Configuration::Model
      )
    end
  end

  describe "#call" do
    before { extension.call }

    context "with default configuration" do
      let(:test_configuration) { configuration.minimize }

      it "messages client" do
        expect(client).to have_received(:call).with(
          Milestoner::Configuration::Model[
            documentation_format: "adoc",
            prefixes: %w[Fixed Added Updated Removed Refactored],
            version: "0.0.0"
          ]
        )
      end
    end

    context "with custom configuration" do
      let :test_configuration do
        configuration.merge extensions_milestoner_documentation_format: "adoc",
                            extensions_milestoner_prefixes: %w[Added],
                            project_version: "1.2.3"
      end

      it "messages client" do
        expect(client).to have_received(:call).with(
          Milestoner::Configuration::Model[
            documentation_format: "adoc",
            prefixes: %w[Added],
            version: "1.2.3"
          ]
        )
      end
    end
  end
end
