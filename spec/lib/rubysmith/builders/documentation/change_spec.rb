# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Documentation::Change do
  using Refinements::Pathnames

  subject(:builder) { described_class.new configuration }

  include_context "with application container"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled with Markdown format" do
      let :configuration do
        minimum_configuration.with build_changes: true, documentation_format: "md"
      end

      it "builds CHANGES" do
        expect(temp_dir.join("test", "CHANGES.md").read).to eq(<<~CONTENT)
          # Changes

          ## 0.1.0 (2020-01-01)

          - Added initial implementation.
        CONTENT
      end
    end

    context "when enabled with ASCII Doc format" do
      let :configuration do
        minimum_configuration.with build_changes: true, documentation_format: "adoc"
      end

      it "builds CHANGES" do
        expect(temp_dir.join("test", "CHANGES.adoc").read).to eq(<<~CONTENT)
          = Changes

          == 0.1.0 (2020-01-01)

          * Added initial implementation.
        CONTENT
      end
    end

    context "when disabled" do
      let(:configuration) { minimum_configuration.minimize }

      it "doesn't build documentation" do
        expect(temp_dir.files.empty?).to eq(true)
      end
    end
  end
end
