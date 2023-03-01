# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Loader do
  subject(:loader) { described_class.with_defaults }

  let :content do
    Rubysmith::Configuration::Content[
      **YAML.load_file(SPEC_ROOT.join("support/fixtures/attributes/default.yml"))
    ]
  end

  describe ".call" do
    it "answers default configuration" do
      expect(described_class.call).to be_a(Rubysmith::Configuration::Content)
    end
  end

  describe ".with_defaults" do
    it "answers default configuration" do
      expect(described_class.with_defaults.call).to eq(content)
    end
  end

  describe "#call" do
    it "answers default configuration" do
      expect(loader.call).to eq(content)
    end

    it "answers enhanced configuration" do
      loader = described_class.new enhancers: {
        template_root: Rubysmith::Configuration::Enhancers::TemplateRoot
      }

      expect(loader.call).to have_attributes(
        template_root: Bundler.root.join("lib/rubysmith/templates")
      )
    end

    it "answers frozen configuration" do
      expect(loader.call).to be_frozen
    end
  end
end
