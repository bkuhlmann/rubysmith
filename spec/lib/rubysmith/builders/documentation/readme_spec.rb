# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Documentation::Readme do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "builds README when enabled with ASCII Doc format and minimum configuration" do
      settings.merge! settings.minimize.merge(build_readme: true, documentation_format: "adoc")
      builder.call

      expect(temp_dir.join("test/README.adoc").read).to eq(
        SPEC_ROOT.join("support/fixtures/readmes/minimum.adoc").read
      )
    end

    it "builds README when enabled with ASCII Doc format and maximum configuration" do
      settings.merge! settings.maximize.merge(documentation_format: "adoc")
      builder.call

      expect(temp_dir.join("test/README.adoc").read).to eq(
        SPEC_ROOT.join("support/fixtures/readmes/maximum.adoc").read
      )
    end

    it "builds README when enabled with Markdown format and minimum configuration" do
      settings.merge! settings.minimize.merge(build_readme: true, documentation_format: "md")
      builder.call

      expect(temp_dir.join("test/README.md").read).to eq(
        SPEC_ROOT.join("support/fixtures/readmes/minimum.md").read
      )
    end

    it "builds README when enabled with Markdown format and maximum configuration" do
      settings.merge! settings.maximize.merge(documentation_format: "md")
      builder.call

      expect(temp_dir.join("test/README.md").read).to eq(
        SPEC_ROOT.join("support/fixtures/readmes/maximum.md").read
      )
    end

    it "answers true when enabled" do
      settings.merge! settings.merge(build_readme: true)
      expect(builder.call).to be(true)
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build README" do
        builder.call
        expect(temp_dir.files.empty?).to be(true)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
