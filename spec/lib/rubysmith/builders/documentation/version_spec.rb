# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Documentation::Version do
  using Refinements::Pathnames
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application container"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled with Markdown format" do
      let :test_configuration do
        configuration.minimize.merge build_versions: true, documentation_format: "md"
      end

      it "builds default version history" do
        expect(temp_dir.join("test", "VERSIONS.md").read).to eq(<<~CONTENT)
          # Versions

          ## 0.0.0 (2020-01-01)

          - Added initial implementation.
        CONTENT
      end
    end

    context "when enabled with Markdown format and custom version" do
      let :test_configuration do
        configuration.minimize.merge build_versions: true,
                                     documentation_format: "md",
                                     project_version: "1.2.3"
      end

      it "builds default version history" do
        expect(temp_dir.join("test", "VERSIONS.md").read).to eq(<<~CONTENT)
          # Versions

          ## 1.2.3 (2020-01-01)

          - Added initial implementation.
        CONTENT
      end
    end

    context "when enabled with ASCII Doc format" do
      let :test_configuration do
        configuration.minimize.merge build_versions: true, documentation_format: "adoc"
      end

      it "builds default version history" do
        expect(temp_dir.join("test", "VERSIONS.adoc").read).to eq(<<~CONTENT)
          = Versions

          == 0.0.0 (2020-01-01)

          * Added initial implementation.
        CONTENT
      end
    end

    context "when enabled with ASCII Doc format and custom version" do
      let :test_configuration do
        configuration.minimize.merge build_versions: true,
                                     documentation_format: "adoc",
                                     project_version: "1.2.3"
      end

      it "builds default version history" do
        expect(temp_dir.join("test", "VERSIONS.adoc").read).to eq(<<~CONTENT)
          = Versions

          == 1.2.3 (2020-01-01)

          * Added initial implementation.
        CONTENT
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't build documentation" do
        expect(temp_dir.files.empty?).to be(true)
      end
    end
  end
end
