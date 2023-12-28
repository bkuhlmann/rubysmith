# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Reek do
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:configuration_path) { temp_dir.join "test", ".reek.yml" }

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_reek: true }

      it "builds configuration" do
        expect(configuration_path.read).to eq(<<~CONTENT)
          exclude_paths:
            - tmp
            - vendor

          detectors:
            LongParameterList:
              enabled: false
        CONTENT
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't build configuration" do
        expect(configuration_path.exist?).to be(false)
      end
    end
  end
end
