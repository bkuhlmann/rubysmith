# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Configuration::Content do
  using Refinements::Structs

  subject(:content) { described_class[project_name: "test"] }

  let(:template_root) { Bundler.root.join "lib", "rubysmith", "templates" }
  let(:target_root) { Bundler.root }

  describe "#initialize" do
    let :proof do
      {
        action_build: nil,
        action_config: nil,
        action_help: nil,
        action_version: nil,
        author_email: nil,
        author_name: nil,
        author_url: nil,
        build_amazing_print: nil,
        build_bundler_leak: nil,
        build_console: nil,
        build_debug: nil,
        build_documentation: nil,
        build_git: nil,
        build_git_lint: nil,
        build_guard: nil,
        build_minimum: nil,
        build_rake: nil,
        build_reek: nil,
        build_refinements: nil,
        build_rspec: nil,
        build_rubocop: nil,
        build_setup: nil,
        build_simple_cov: nil,
        build_zeitwerk: nil,
        builders_pragmater_comments: nil,
        builders_pragmater_includes: nil,
        documentation_format: nil,
        documentation_license: nil,
        now: nil,
        project_name: nil,
        target_root: target_root,
        template_path: nil,
        template_root: template_root
      }
    end

    it "answers default hash" do
      expect(described_class.new).to have_attributes(proof)
    end
  end

  describe "#with" do
    it "answers combination of old and new struct with single attribute" do
      proof = described_class[project_name: "test", action_help: true]
      expect(content.with(action_help: true)).to eq(proof)
    end

    it "answers combination of old and new struct with multiple attributes" do
      proof = described_class[project_name: "test", build_console: true, build_git: true]
      expect(content.with(project_name: "test", build_console: true, build_git: true)).to eq(proof)
    end
  end

  describe "#minimize" do
    let :proof do
      described_class[
        build_amazing_print: false,
        build_bundler_leak: false,
        build_console: false,
        build_debug: false,
        build_documentation: false,
        build_git: false,
        build_git_lint: false,
        build_guard: false,
        build_minimum: true,
        build_rake: false,
        build_reek: false,
        build_refinements: false,
        build_rspec: false,
        build_rubocop: false,
        build_setup: false,
        build_simple_cov: false,
        build_zeitwerk: false,
        project_name: "test",
        target_root: target_root,
        template_root: template_root
      ]
    end

    it "disables all build options except minimum" do
      content.build_minimum = true
      expect(content.minimize).to eq(proof)
    end

    it "mutates itself" do
      content.minimize
      expect(content).to have_attributes(build_amazing_print: false)
    end
  end

  describe "#project_label" do
    it "answers capitalized project label with single project name" do
      expect(content.project_label).to eq("Test")
    end

    it "answers titleized label with underscored project name" do
      updated_content = content.merge project_name: "test_underscore"
      expect(updated_content.project_label).to eq("Test Underscore")
    end

    it "answers titleized project label with dashed project name" do
      updated_content = content.merge project_name: "test-dash"
      expect(updated_content.project_label).to eq("Test Dash")
    end
  end

  describe "#project_class" do
    it "answers capitalized project class with single project name" do
      expect(content.project_class).to eq("Test")
    end

    it "answers camelcased project class with underscored project name" do
      updated_content = content.merge project_name: "test_underscore"
      expect(updated_content.project_class).to eq("TestUnderscore")
    end

    it "answers namespaced project class with dashed project name" do
      updated_content = content.merge project_name: "test-dash"
      expect(updated_content.project_class).to eq("Test::Dash")
    end
  end

  describe "#project_root" do
    it "answers unchanged project root path with single project name" do
      expect(content.project_root).to eq(Bundler.root.join("test"))
    end

    it "answers unchanged project root path with underscored project name" do
      updated_content = content.merge project_name: "test_underscore"
      expect(updated_content.project_root).to eq(Bundler.root.join("test_underscore"))
    end

    it "answers unchanged project root path with dashed project name" do
      updated_content = content.merge project_name: "test-dash"
      expect(updated_content.project_root).to eq(Bundler.root.join("test-dash"))
    end
  end

  describe "#project_path" do
    it "answers single project path with single project name" do
      expect(content.project_path).to eq("test")
    end

    it "answers underscored project path with underscored project name" do
      updated_content = content.merge project_name: "test_underscore"
      expect(updated_content.project_path).to eq("test_underscore")
    end

    it "answers nested project path with dashed project name" do
      updated_content = content.merge project_name: "test-dash"
      expect(updated_content.project_path).to eq("test/dash")
    end
  end

  describe "#to_pathway" do
    it "answers pathway" do
      expect(content.to_pathway).to eq(
        Rubysmith::Pathway[start_root: template_root, end_root: target_root]
      )
    end
  end
end
