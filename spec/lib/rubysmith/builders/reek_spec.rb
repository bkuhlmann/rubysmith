# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Reek do
  subject(:builder) { described_class.new configuration }

  include_context "with application container"

  let(:configuration_path) { temp_dir.join "test", ".reek.yml" }

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled" do
      let(:configuration) { application_configuration.minimize.with build_reek: true }

      it "builds configuration" do
        expect(configuration_path.read).to eq(<<~CONTENT)
          exclude_paths:
            - tmp
            - vendor
        CONTENT
      end
    end

    context "when disabled" do
      let(:configuration) { application_configuration.minimize }

      it "doesn't build configuration" do
        expect(configuration_path.exist?).to eq(false)
      end
    end
  end
end
