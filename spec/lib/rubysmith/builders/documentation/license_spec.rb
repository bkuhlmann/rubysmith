# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Documentation::License do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    context "with ASCII Doc format" do
      before do
        settings.merge! settings.minimize.merge(build_license: true, documentation_format: "adoc")
      end

      it "builds Apache license" do
        settings.merge! settings.merge(license_name: "apache")
        builder.call

        expect(temp_dir.join("test", "LICENSE.adoc").read).to include("= Apache License")
      end

      it "includes Apache copyright" do
        settings.merge! settings.merge(license_name: "apache")
        builder.call

        expect(temp_dir.join("test", "LICENSE.adoc").read).to include(
          "Copyright 2020 link:https://undefined.io/team/undefined[Jill Smith]."
        )
      end

      it "builds Fair license" do
        settings.merge! settings.merge(license_name: "fair")
        builder.call

        expect(temp_dir.join("test", "LICENSE.adoc").read).to include("= Functional Source License")
      end

      it "includes Fair copyright" do
        settings.merge! settings.merge(license_name: "fair")
        builder.call

        expect(temp_dir.join("test", "LICENSE.adoc").read).to include(
          "Copyright 2020 link:https://undefined.io/team/undefined[Jill Smith]"
        )
      end

      it "builds Hippocratic license" do
        settings.merge! settings.merge(license_name: "hippocratic")
        builder.call

        expect(temp_dir.join("test", "LICENSE.adoc").read).to include("= Hippocratic License")
      end

      it "builds MIT license" do
        settings.merge! settings.merge(license_name: "mit")
        builder.call

        expect(temp_dir.join("test", "LICENSE.adoc").read).to include(
          %(THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND)
        )
      end

      it "includes MIT copyright" do
        settings.merge! settings.merge(license_name: "mit")
        builder.call

        expect(temp_dir.join("test", "LICENSE.adoc").read).to include(
          "Copyright 2020 link:https://undefined.io/team/undefined[Jill Smith]."
        )
      end
    end

    context "with Markdown format" do
      before do
        settings.merge! settings.minimize.merge(build_license: true, documentation_format: "md")
      end

      it "builds Apache license" do
        settings.merge! settings.merge(license_name: "apache")
        builder.call

        expect(temp_dir.join("test", "LICENSE.md").read).to include("# Apache License")
      end

      it "includes Apache copyright" do
        settings.merge! settings.merge(license_name: "apache")
        builder.call

        expect(temp_dir.join("test", "LICENSE.md").read).to include(
          "Copyright 2020 [Jill Smith](https://undefined.io/team/undefined)."
        )
      end

      it "builds Fair license" do
        settings.merge! settings.merge(license_name: "fair")
        builder.call

        expect(temp_dir.join("test", "LICENSE.md").read).to include("# Functional Source License")
      end

      it "includes Fair copyright" do
        settings.merge! settings.merge(license_name: "fair")
        builder.call

        expect(temp_dir.join("test", "LICENSE.md").read).to include(
          "Copyright 2020 [Jill Smith](https://undefined.io/team/undefined)"
        )
      end

      it "builds Hippocratic license" do
        settings.merge! settings.merge(license_name: "hippocratic")
        builder.call

        expect(temp_dir.join("test", "LICENSE.md").read).to include("# Hippocratic License")
      end

      it "builds MIT license" do
        settings.merge! settings.merge(license_name: "mit")
        builder.call

        expect(temp_dir.join("test", "LICENSE.md").read).to include(
          %(THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND)
        )
      end

      it "includes MIT copyright" do
        settings.merge! settings.merge(license_name: "mit")
        builder.call

        expect(temp_dir.join("test", "LICENSE.md").read).to include(
          "Copyright 2020 [Jill Smith](https://undefined.io/team/undefined)."
        )
      end
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
