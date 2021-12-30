# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Extensions::Tocer do
  using Refinements::Pathnames

  subject(:extension) { described_class.new test_configuration }

  include_context "with application container"

  describe ".call" do
    it "answers configuration" do
      expect(described_class.call(configuration)).to be_a(Rubysmith::Configuration::Content)
    end
  end

  describe "#call" do
    let(:readme_path) { temp_dir.join("test/README.md") }

    let :snippet do
      <<~BODY
        <!-- Tocer[start]: Auto-generated, don't remove. -->

        ## Table of Contents

          - [Features](#features)
      BODY
    end

    before do
      Rubysmith::Builders::Documentation::Readme.call test_configuration
      extension.call
    end

    context "with minimum configuration" do
      let :test_configuration do
        configuration.minimize.with build_readme: true, documentation_format: "md"
      end

      it "adds table of contents" do
        expect(readme_path.read).to include(snippet)
      end
    end

    context "with maximum configuration" do
      let :test_configuration do
        configuration.maximize.with documentation_format: "md"
      end

      it "adds table of contents" do
        expect(readme_path.read).to include(snippet)
      end
    end

    context "with custom includes" do
      let :test_configuration do
        configuration.maximize.with extensions_tocer_includes: %w[*.txt], documentation_format: "md"
      end

      it "adds custom label" do
        expect(readme_path.read).not_to include("## Table of Contents")
      end
    end

    context "with custom label" do
      let :test_configuration do
        configuration.maximize.with extensions_tocer_label: "# TEST TOC", documentation_format: "md"
      end

      it "adds custom label" do
        expect(readme_path.read).to include("# TEST TOC")
      end
    end
  end
end
