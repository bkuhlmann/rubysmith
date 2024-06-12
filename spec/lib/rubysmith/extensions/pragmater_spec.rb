# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Extensions::Pragmater do
  using Refinements::Pathname

  subject(:extension) { described_class.new }

  include_context "with application dependencies"

  before { temp_dir.join("test/Gemfile").make_ancestors.touch }

  describe ".call" do
    it "answers configuration" do
      expect(described_class.call).to be_a(Rubysmith::Configuration::Model)
    end
  end

  describe "#call" do
    it "adds frozen string literal" do
      extension.call
      expect(temp_dir.join("test/Gemfile").read).to eq("# frozen_string_literal: true\n")
    end

    it "answers settings" do
      expect(extension.call).to eq(settings)
    end
  end
end
