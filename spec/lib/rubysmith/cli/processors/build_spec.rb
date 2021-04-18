# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Processors::Build do
  subject(:processor) { described_class.new builders: [builder] }

  let(:builder) { class_spy Rubysmith::Builders::Core }

  describe ".with_minimum" do
    it "answers procesor" do
      expect(described_class.with_minimum).to be_a(described_class)
    end
  end

  describe "#call" do
    it "calls builders" do
      processor.call project_name: "test"

      expect(builder).to have_received(:call).with(
        Rubysmith::CLI::Configuration::Content[project_name: "test"]
      )
    end
  end
end
