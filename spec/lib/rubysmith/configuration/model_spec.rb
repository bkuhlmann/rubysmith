# frozen_string_literal: true

require "spec_helper"
require "yaml"

RSpec.describe Rubysmith::Configuration::Model do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:record) { described_class.new project_name: "test" }

  describe "#maximum" do
    let :proof do
      described_class[
        **YAML.load_file(SPEC_ROOT.join("support/fixtures/attributes/maximum.yml"))
              .merge!(project_name: "test")
      ]
    end

    it "disables all build options except minimum" do
      expect(record.maximize).to eq(proof)
    end

    it "doesn't mutate itself" do
      expect(record.maximize).not_to eq(record)
    end

    it "answers as frozen" do
      expect(record.maximize).to be_frozen
    end
  end

  describe "#minimize" do
    let :proof do
      described_class[
        **YAML.load_file(SPEC_ROOT.join("support/fixtures/attributes/minimum.yml"))
              .merge!(project_name: "test")
      ]
    end

    it "disables all build options except minimum" do
      expect(record.minimize).to eq(proof)
    end

    it "doesn't mutate itself" do
      expect(record.minimize).not_to eq(record)
    end

    it "answers as frozen" do
      expect(record.minimize).to be_frozen
    end
  end

  describe "#author_name" do
    it "answers given and family name" do
      record = described_class[author_given_name: "Test", author_family_name: "Example"]
      expect(record.author_name).to eq("Test Example")
    end

    it "answers partial name when there is an empty string" do
      record = described_class[author_given_name: "", author_family_name: "Example"]
      expect(record.author_name).to eq("Example")
    end

    it "answers given name only" do
      record = described_class[author_given_name: "Test"]
      expect(record.author_name).to eq("Test")
    end

    it "answers family name only" do
      record = described_class[author_family_name: "Example"]
      expect(record.author_name).to eq("Example")
    end

    it "answers blank string name doesn't exist" do
      expect(record.author_name).to eq("")
    end
  end

  describe "#license_label_version" do
    it "answers label and version" do
      record = described_class[license_label: "Hippocratic", license_version: "3.0"]
      expect(record.license_label_version).to eq("Hippocratic-3.0")
    end

    it "answers partial label when there is an empty string" do
      record = described_class[license_label: "", license_version: "3.0"]
      expect(record.license_label_version).to eq("3.0")
    end

    it "answers label only" do
      record = described_class[license_label: "Hippocratic"]
      expect(record.license_label_version).to eq("Hippocratic")
    end

    it "answers version only" do
      record = described_class[license_label: "3.0"]
      expect(record.license_label_version).to eq("3.0")
    end

    it "answers blank string when label and version don't exist" do
      expect(record.license_label_version).to eq("")
    end
  end

  describe "#project_class" do
    it "answers capitalized class with single project name" do
      expect(record.project_class).to eq("Test")
    end

    it "answers camelcased class with underscored project name" do
      updated_record = record.merge project_name: "test_underscore"
      expect(updated_record.project_class).to eq("TestUnderscore")
    end

    it "answers class with dashed project name" do
      updated_record = record.merge project_name: "test-dash"
      expect(updated_record.project_class).to eq("Dash")
    end
  end

  describe "#project_namespaced_class" do
    it "answers namespaced class with single project name" do
      expect(record.project_namespaced_class).to eq("Test")
    end

    it "answers namespaced class with underscored project name" do
      updated_record = record.merge project_name: "test_underscore"
      expect(updated_record.project_namespaced_class).to eq("TestUnderscore")
    end

    it "answers namespaced class with dashed project name" do
      updated_record = record.merge project_name: "test-dash"
      expect(updated_record.project_namespaced_class).to eq("Test::Dash")
    end
  end

  describe "#project_label" do
    it "answers capitalized project label with single project name" do
      expect(record.project_label).to eq("Test")
    end

    it "answers titleized label with underscored project name" do
      updated_record = record.merge project_name: "test_underscore"
      expect(updated_record.project_label).to eq("Test Underscore")
    end

    it "answers titleized project label with dashed project name" do
      updated_record = record.merge project_name: "test-dash"
      expect(updated_record.project_label).to eq("Test Dash")
    end
  end

  describe "#project_levels" do
    it "answers zero with single project name" do
      expect(record.project_levels).to eq(0)
    end

    it "answers one with single dashed project name" do
      updated_record = record.merge project_name: "test-dash"
      expect(updated_record.project_levels).to eq(1)
    end

    it "answers more than one with multi-dashed project name" do
      updated_record = record.merge project_name: "test-one-two"
      expect(updated_record.project_levels).to eq(2)
    end
  end

  describe "#project_path" do
    it "answers single project path with single project name" do
      expect(record.project_path).to eq("test")
    end

    it "answers underscored project path with underscored project name" do
      updated_record = record.merge project_name: "test_underscore"
      expect(updated_record.project_path).to eq("test_underscore")
    end

    it "answers nested project path with dashed project name" do
      updated_record = record.merge project_name: "test-dash"
      expect(updated_record.project_path).to eq("test/dash")
    end
  end

  describe "#project_root" do
    let(:target_root) { Bundler.root }

    it "answers unchanged project root path with single project name" do
      updated_record = record.merge(target_root:)
      expect(updated_record.project_root).to eq(Bundler.root.join("test"))
    end

    it "answers unchanged project root path with underscored project name" do
      updated_record = record.merge(project_name: "test_underscore", target_root:)
      expect(updated_record.project_root).to eq(Bundler.root.join("test_underscore"))
    end

    it "answers unchanged project root path with dashed project name" do
      updated_record = record.merge(project_name: "test-dash", target_root:)
      expect(updated_record.project_root).to eq(Bundler.root.join("test-dash"))
    end
  end

  describe "#computed_project_uri_community" do
    it "answers formatted URL" do
      updated_record = record.merge project_uri_community: "test.com/%<project_name>s/commons"
      expect(updated_record.computed_project_uri_community).to eq("test.com/test/commons")
    end
  end

  describe "#computed_project_uri_conduct" do
    it "answers formatted URL" do
      updated_record = record.merge project_uri_conduct: "test.com/%<project_name>s/conduct"
      expect(updated_record.computed_project_uri_conduct).to eq("test.com/test/conduct")
    end
  end

  describe "#computed_project_uri_contributions" do
    it "answers formatted URL" do
      updated_record = record.merge project_uri_contributions: "test.com/%<project_name>s/contribs"
      expect(updated_record.computed_project_uri_contributions).to eq("test.com/test/contribs")
    end
  end

  describe "#computed_project_uri_dcoo" do
    it "answers formatted URL" do
      updated_record = record.merge project_uri_dcoo: "test.com/%<project_name>s/dcoo"
      expect(updated_record.computed_project_uri_dcoo).to eq("test.com/test/dcoo")
    end
  end

  describe "#computed_project_uri_download" do
    it "answers formatted URL" do
      updated_record = record.merge project_uri_download: "test.com/%<project_name>s/latest"
      expect(updated_record.computed_project_uri_download).to eq("test.com/test/latest")
    end
  end

  describe "#computed_project_uri_funding" do
    it "answers formatted URL" do
      updated_record = record.merge project_uri_funding: "test.com/%<project_name>s/funding"
      expect(updated_record.computed_project_uri_funding).to eq("test.com/test/funding")
    end
  end

  describe "#computed_project_uri_home" do
    it "answers formatted URL" do
      updated_record = record.merge project_uri_home: "test.com/%<project_name>s"
      expect(updated_record.computed_project_uri_home).to eq("test.com/test")
    end
  end

  describe "#computed_project_uri_issues" do
    it "answers formatted URL" do
      updated_record = record.merge project_uri_issues: "test.com/%<project_name>s/issues"
      expect(updated_record.computed_project_uri_issues).to eq("test.com/test/issues")
    end
  end

  describe "#computed_project_uri_license" do
    it "answers formatted URL" do
      updated_record = record.merge project_uri_license: "test.com/%<project_name>s/license"
      expect(updated_record.computed_project_uri_license).to eq("test.com/test/license")
    end
  end

  describe "#computed_project_uri_security" do
    it "answers formatted URL" do
      updated_record = record.merge project_uri_security: "test.com/%<project_name>s/security"
      expect(updated_record.computed_project_uri_security).to eq("test.com/test/security")
    end
  end

  describe "#computed_project_uri_source" do
    it "answers formatted URL" do
      updated_record = record.merge project_uri_source: "test.com/%<project_name>s/source"
      expect(updated_record.computed_project_uri_source).to eq("test.com/test/source")
    end
  end

  describe "#computed_project_uri_versions" do
    it "answers formatted URL" do
      updated_record = record.merge project_uri_versions: "test.com/%<project_name>s/versions"
      expect(updated_record.computed_project_uri_versions).to eq("test.com/test/versions")
    end
  end

  describe "#ascii_doc?" do
    it "answers true when ASCII Doc format" do
      updated_record = record.merge documentation_format: "adoc"
      expect(updated_record.ascii_doc?).to be(true)
    end

    it "answers false when other format" do
      updated_record = record.merge documentation_format: "test"
      expect(updated_record.ascii_doc?).to be(false)
    end
  end

  describe "#markdown?" do
    it "answers true when Markdown format" do
      updated_record = record.merge documentation_format: "md"
      expect(updated_record.markdown?).to be(true)
    end

    it "answers false when other format" do
      updated_record = record.merge documentation_format: "test"
      expect(updated_record.markdown?).to be(false)
    end
  end

  describe "#pathway" do
    let(:target_root) { Bundler.root }

    it "answers pathway" do
      updated_record = record.merge(target_root:)

      expect(updated_record.pathway).to eq(
        Rubysmith::Pathway[start_root: nil, end_root: target_root]
      )
    end
  end

  describe "#template_root" do
    include_context "with temporary directory"

    let(:existing_path) { temp_dir.join("a/path").make_path }
    let(:missing_path) { temp_dir.join "a/missing/path" }

    it "answers nil by default" do
      expect(record.template_root).to be(nil)
    end

    it "answers first existing root path" do
      record = described_class[template_roots: [missing_path, existing_path]]
      expect(record.template_root).to eq(existing_path)
    end

    it "answers first existing full path" do
      record = described_class[
        template_roots: [missing_path, existing_path],
        template_path: "template.rb.erb"
      ]
      existing_path.join("template.rb.erb").touch

      expect(record.template_root).to eq(existing_path)
    end

    it "answers nil when no paths exists" do
      record = described_class[template_roots: [missing_path, missing_path]]
      expect(record.template_root).to be(nil)
    end
  end
end
