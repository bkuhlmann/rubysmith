# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Documentation::Readme do
  using Refinements::Pathnames
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application container"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled with ASCII Doc format and minimum configuration" do
      let :test_configuration do
        configuration.minimize.merge build_readme: true, documentation_format: "adoc"
      end

      it "builds README" do
        expect(temp_dir.join("test", "README.adoc").read).to eq(
          Bundler.root.join("spec/support/fixtures/boms/readme-minimum.adoc").read
        )
      end
    end

    context "when enabled with ASCII Doc format and maximum configuration" do
      let(:test_configuration) { configuration.maximize.merge documentation_format: "adoc" }

      it "builds README" do
        expect(temp_dir.join("test", "README.adoc").read).to eq(
          Bundler.root.join("spec/support/fixtures/boms/readme-maximum.adoc").read
        )
      end
    end

    context "when enabled with Markdown format and minimum configuration" do
      let :test_configuration do
        configuration.minimize.merge build_readme: true, documentation_format: "md"
      end

      it "builds README" do
        expect(temp_dir.join("test/README.md").read).to eq(
          Bundler.root.join("spec/support/fixtures/boms/readme-minimum.md").read
        )
      end
    end

    context "when enabled with Markdown format and maximum configuration" do
      let(:test_configuration) { configuration.maximize.merge documentation_format: "md" }

      it "builds README" do
        expect(temp_dir.join("test/README.md").read).to eq(
          Bundler.root.join("spec/support/fixtures/boms/readme-maximum.md").read
        )
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't build README" do
        expect(temp_dir.files.empty?).to eq(true)
      end
    end
  end
end
