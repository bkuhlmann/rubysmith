# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Reek, :realm do
  subject(:builder) { described_class.new realm }

  let(:configuration_path) { temp_dir.join "test", ".reek.yml" }

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled" do
      let(:realm) { default_realm.with build_reek: true }

      it "builds configuration" do
        expect(configuration_path.read).to eq(
          <<~CONTENT
            exclude_paths:
              - tmp
              - vendor
          CONTENT
        )
      end
    end

    context "when disabled" do
      let(:realm) { default_realm.with build_reek: false }

      it "doesn't build configuration" do
        expect(configuration_path.exist?).to eq(false)
      end
    end
  end
end
