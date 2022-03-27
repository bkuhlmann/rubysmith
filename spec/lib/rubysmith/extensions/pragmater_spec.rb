# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Extensions::Pragmater do
  using Refinements::Pathnames
  using Refinements::Structs

  subject(:extension) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:test_path) { temp_dir.join "test", "test.rb" }

  describe ".call" do
    it "answers configuration" do
      expect(described_class.call(configuration)).to be_a(Rubysmith::Configuration::Content)
    end
  end

  describe "#call" do
    before do
      test_path.deep_touch
      extension.call
    end

    context "with defaults" do
      let(:test_configuration) { configuration.minimize }

      it "adds pragmas" do
        expect(test_path.read).to eq("# frozen_string_literal: true\n")
      end
    end

    context "with custom comments" do
      let :test_configuration do
        configuration.minimize.merge extensions_pragmater_comments: ["# encoding: UTF-8"]
      end

      it "adds custom pragmas" do
        expect(test_path.read).to eq("# encoding: UTF-8\n")
      end
    end

    context "with custom includes" do
      let :test_configuration do
        configuration.minimize.merge extensions_pragmater_includes: ["**/*.txt"]
      end

      it "doesn't add pragmas" do
        expect(test_path.read).to eq("")
      end
    end
  end
end
