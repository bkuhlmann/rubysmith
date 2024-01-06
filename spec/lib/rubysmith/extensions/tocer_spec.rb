# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Extensions::Tocer do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:extension) { described_class.new test_configuration, client: }

  include_context "with application dependencies"

  let(:client) { instance_spy Tocer::Runner }

  describe ".call" do
    it "answers configuration" do
      expect(described_class.call(configuration, client:)).to be_a(Rubysmith::Configuration::Model)
    end
  end

  describe "#call" do
    context "with readme enabled" do
      let(:test_configuration) { configuration.minimize.merge build_readme: true }

      it "delegates to client" do
        extension.call
        expect(client).to have_received(:call)
      end

      it "answers configuration" do
        expect(extension.call).to eq(test_configuration)
      end
    end

    context "with readme disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't delegate to client" do
        extension.call
        expect(client).not_to have_received(:call)
      end

      it "answers configuration" do
        expect(extension.call).to eq(test_configuration)
      end
    end
  end
end
