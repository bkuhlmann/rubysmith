# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Documentation::License do
  using Refinements::Pathnames

  subject(:builder) { described_class.new configuration }

  include_context "with application container"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled with MIT and Markdown format" do
      let :configuration do
        application_configuration.minimize.with build_license: true,
                                                documentation_license: "mit",
                                                documentation_format: "md"
      end

      it "builds LICENSE" do
        expect(temp_dir.join("test", "LICENSE.md").read).to include(
          "Copyright 2020 [Jill Smith](https://www.jillsmith.com)."
        )
      end
    end

    context "when enabled with Apache and ASCII Doc format" do
      let :configuration do
        application_configuration.minimize.with build_license: true,
                                                documentation_license: "apache",
                                                documentation_format: "adoc"
      end

      it "builds LICENSE" do
        expect(temp_dir.join("test", "LICENSE.adoc").read).to include(
          "Copyright 2020 link:https://www.jillsmith.com[Jill Smith]."
        )
      end
    end

    context "when disabled" do
      let(:configuration) { application_configuration.minimize }

      it "doesn't build documentation" do
        expect(temp_dir.files.empty?).to eq(true)
      end
    end
  end
end
