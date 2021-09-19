# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Documentation::Conduct do
  using Refinements::Pathnames

  subject(:builder) { described_class.new configuration }

  include_context "with application container"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled with Markdown format" do
      let :configuration do
        application_configuration.minimize.with build_conduct: true, documentation_format: "md"
      end

      it "builds CODE_OF_CONDUCT" do
        expect(temp_dir.join("test", "CODE_OF_CONDUCT.md").read).to include(
          "[Jill Smith](mailto:jill@example.com?subject=Conduct)"
        )
      end
    end

    context "when enabled with ASCII Doc format" do
      let :configuration do
        application_configuration.minimize.with build_conduct: true, documentation_format: "adoc"
      end

      it "builds CODE_OF_CONDUCT" do
        expect(temp_dir.join("test", "CODE_OF_CONDUCT.adoc").read).to include(
          "link:mailto:jill@example.com?subject=Conduct[Jill Smith]"
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
