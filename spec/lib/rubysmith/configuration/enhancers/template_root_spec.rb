# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Enhancers::TemplateRoot do
  subject(:enhancer) { described_class }

  describe "#call" do
    let(:content) { Rubysmith::Configuration::Content.new template_roots: [Pathname.pwd] }

    it "answers path array with overrides prepended" do
      template_roots = enhancer.call(content).template_roots
      expect(template_roots).to eq([Bundler.root.join("lib/rubysmith/templates"), Pathname.pwd])
    end

    it "answers empty arrary with no overrides" do
      template_roots = described_class.call(content, overrides: nil).template_roots
      expect(template_roots).to contain_exactly(Pathname.pwd)
    end
  end
end
