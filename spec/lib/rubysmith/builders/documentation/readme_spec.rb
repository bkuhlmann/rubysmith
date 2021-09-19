# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Documentation::Readme do
  using Refinements::Pathnames

  subject(:builder) { described_class.new configuration }

  include_context "with application container"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled without any format" do
      let :configuration do
        minimum_configuration.with build_readme: true, documentation_format: nil
      end

      it "builds README with minimum options" do
        expect(temp_dir.join("test/README.md").read).to eq(
          Bundler.root.join("spec", "support", "boms", "readme-minimum.md").read
        )
      end
    end

    context "when enabled with Markdown format" do
      let :configuration do
        minimum_configuration.with build_readme: true, documentation_format: "md"
      end

      it "builds README with minimum options" do
        expect(temp_dir.join("test/README.md").read).to eq(
          Bundler.root.join("spec", "support", "boms", "readme-minimum.md").read
        )
      end
    end

    context "when enabled with Markdown format and maximum options" do
      let :configuration do
        minimum_configuration.with build_readme: true,
                                   build_setup: true,
                                   build_console: true,
                                   build_circle_ci: true,
                                   build_rubocop: true,
                                   documentation_format: "md"
      end

      it "builds README" do
        expect(temp_dir.join("test/README.md").read).to eq(
          Bundler.root.join("spec", "support", "boms", "readme-maximum.md").read
        )
      end
    end

    context "when enabled with ASCII Doc format and minimum options" do
      let :configuration do
        minimum_configuration.with build_readme: true, documentation_format: "adoc"
      end

      it "builds README" do
        expect(temp_dir.join("test", "README.adoc").read).to eq(
          Bundler.root.join("spec", "support", "boms", "readme-minimum.adoc").read
        )
      end
    end

    context "when enabled with ASCII Doc format and maximum options" do
      let :configuration do
        minimum_configuration.with build_readme: true,
                                   build_circle_ci: true,
                                   build_console: true,
                                   build_rubocop: true,
                                   build_setup: true,
                                   documentation_format: "adoc"
      end

      it "builds README" do
        expect(temp_dir.join("test", "README.adoc").read).to eq(
          Bundler.root.join("spec", "support", "boms", "readme-maximum.adoc").read
        )
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
