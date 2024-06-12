# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Documentation::License do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "builds LICENSE when enabled with Apache and ASCII Doc format" do
      settings.merge! settings.minimize.merge(
        build_license: true,
        documentation_format: "adoc",
        license_name: "apache"
      )

      builder.call

      expect(temp_dir.join("test", "LICENSE.adoc").read).to include(
        "Copyright 2020 link:https://acme.io/team/jill_smith[Jill Smith]."
      )
    end

    it "builds LICENSE when enabled with Apache and Markdown format" do
      settings.merge! settings.minimize.merge(
        build_license: true,
        documentation_format: "md",
        license_name: "apache"
      )

      builder.call

      expect(temp_dir.join("test", "LICENSE.md").read).to include(
        "Copyright 2020 [Jill Smith](https://acme.io/team/jill_smith)."
      )
    end

    it "builds LICENSE when enabled with Hippocratic and ASCII Doc format" do
      settings.merge! settings.minimize.merge(
        build_license: true,
        documentation_format: "adoc",
        license_name: "hippocratic"
      )

      builder.call

      expect(temp_dir.join("test", "LICENSE.adoc").read).to include("= Hippocratic License")
    end

    it "builds LICENSE when enabled with Hippocratic and Markdown format" do
      settings.merge! settings.minimize.merge(
        build_license: true,
        documentation_format: "md",
        license_name: "hippocratic"
      )

      builder.call

      expect(temp_dir.join("test", "LICENSE.md").read).to include("# Hippocratic License")
    end

    it "builds LICENSE when enabled with MIT and ASCII Doc format" do
      settings.merge! settings.minimize.merge(
        build_license: true,
        documentation_format: "adoc",
        license_name: "mit"
      )

      builder.call

      expect(temp_dir.join("test", "LICENSE.adoc").read).to include(
        "Copyright 2020 link:https://acme.io/team/jill_smith[Jill Smith]."
      )
    end

    it "builds LICENSE when enabled with MIT and Markdown format" do
      settings.merge! settings.minimize.merge(
        build_license: true,
        documentation_format: "md",
        license_name: "mit"
      )

      builder.call

      expect(temp_dir.join("test", "LICENSE.md").read).to include(
        "Copyright 2020 [Jill Smith](https://acme.io/team/jill_smith)."
      )
    end

    it "answers true when enabled" do
      settings.merge! settings.minimize.merge(build_license: true)
      expect(builder.call).to be(true)
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build documentation when disabled" do
        builder.call
        expect(temp_dir.files.empty?).to be(true)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
