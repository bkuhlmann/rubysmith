# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Documentation::License do
  using Refinements::Pathnames

  subject(:builder) { described_class.new test_configuration }

  include_context "with application container"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled with Apache and ASCII Doc format" do
      let :test_configuration do
        configuration.minimize.with build_license: true,
                                    documentation_format: "adoc",
                                    license_name: "apache"
      end

      it "builds LICENSE" do
        expect(temp_dir.join("test", "LICENSE.adoc").read).to include(
          "Copyright 2020 link:https://www.jillsmith.com[Jill Smith]."
        )
      end
    end

    context "when enabled with Apache and Markdown format" do
      let :test_configuration do
        configuration.minimize.with build_license: true,
                                    documentation_format: "md",
                                    license_name: "apache"
      end

      it "builds LICENSE" do
        expect(temp_dir.join("test", "LICENSE.md").read).to include(
          "Copyright 2020 [Jill Smith](https://www.jillsmith.com)."
        )
      end
    end

    context "when enabled with Hippocratic and ASCII Doc format" do
      let :test_configuration do
        configuration.minimize.with build_license: true,
                                    documentation_format: "adoc",
                                    license_name: "hippocratic"
      end

      it "builds LICENSE" do
        expect(temp_dir.join("test", "LICENSE.adoc").read).to include("= HIPPOCRATIC LICENSE")
      end
    end

    context "when enabled with Hippocratic and Markdown format" do
      let :test_configuration do
        configuration.minimize.with build_license: true,
                                    documentation_format: "md",
                                    license_name: "hippocratic"
      end

      it "builds LICENSE" do
        expect(temp_dir.join("test", "LICENSE.md").read).to include("# HIPPOCRATIC LICENSE")
      end
    end

    context "when enabled with MIT and ASCII Doc format" do
      let :test_configuration do
        configuration.minimize.with build_license: true,
                                    documentation_format: "adoc",
                                    license_name: "mit"
      end

      it "builds LICENSE" do
        expect(temp_dir.join("test", "LICENSE.adoc").read).to include(
          "Copyright 2020 link:https://www.jillsmith.com[Jill Smith]."
        )
      end
    end

    context "when enabled with MIT and Markdown format" do
      let :test_configuration do
        configuration.minimize.with build_license: true,
                                    documentation_format: "md",
                                    license_name: "mit"
      end

      it "builds LICENSE" do
        expect(temp_dir.join("test", "LICENSE.md").read).to include(
          "Copyright 2020 [Jill Smith](https://www.jillsmith.com)."
        )
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't build documentation" do
        expect(temp_dir.files.empty?).to eq(true)
      end
    end
  end
end
