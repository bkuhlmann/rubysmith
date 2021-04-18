# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::RubyCritic do
  subject(:builder) { described_class.new configuration }

  include_context "with configuration"

  let(:configuration_path) { temp_dir.join "test", ".rubycritic.yml" }

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled" do
      let(:configuration) { default_configuration.with build_ruby_critic: true }

      it "builds configuration" do
        expect(configuration_path.read).to eq(
          <<~CONTENT
            paths:
              - "lib"
            no_browser: true
          CONTENT
        )
      end
    end

    context "when disabled" do
      let(:configuration) { default_configuration.with build_ruby_critic: false }

      it "doesn't build configuration" do
        expect(configuration_path.exist?).to eq(false)
      end
    end
  end
end
