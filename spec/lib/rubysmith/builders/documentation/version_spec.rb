# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Documentation::Version do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "builds default version history when enabled with Markdown format" do
      settings.merge! settings.minimize.merge(build_versions: true, documentation_format: "md")
      builder.call

      expect(temp_dir.join("test", "VERSIONS.md").read).to eq(<<~CONTENT)
        # Versions

        ## 0.0.0 (2020-01-01)

        - Added initial implementation.
      CONTENT
    end

    it "builds default version history when enabled with Markdown format and custom version" do
      settings.merge! settings.minimize.merge(
        build_versions: true,
        documentation_format: "md",
        project_version: "1.2.3"
      )

      builder.call

      expect(temp_dir.join("test", "VERSIONS.md").read).to eq(<<~CONTENT)
        # Versions

        ## 1.2.3 (2020-01-01)

        - Added initial implementation.
      CONTENT
    end

    it "builds default version history when enabled with ASCII Doc format" do
      settings.merge! settings.minimize.merge(build_versions: true, documentation_format: "adoc")
      builder.call

      expect(temp_dir.join("test", "VERSIONS.adoc").read).to eq(<<~CONTENT)
        = Versions

        == 0.0.0 (2020-01-01)

        * Added initial implementation.
      CONTENT
    end

    it "builds default version history when enabled with ASCII Doc format and custom version" do
      settings.merge! settings.minimize.merge(
        build_versions: true,
        documentation_format: "adoc",
        project_version: "1.2.3"
      )

      builder.call

      expect(temp_dir.join("test", "VERSIONS.adoc").read).to eq(<<~CONTENT)
        = Versions

        == 1.2.3 (2020-01-01)

        * Added initial implementation.
      CONTENT
    end

    it "answers true when enabled" do
      settings.merge! settings.minimize.merge(build_versions: true)
      expect(builder.call).to be(true)
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(temp_dir.files.empty?).to be(true)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
