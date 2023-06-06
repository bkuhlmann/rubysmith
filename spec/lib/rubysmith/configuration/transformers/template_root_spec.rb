# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Transformers::TemplateRoot do
  include Dry::Monads[:result]

  subject(:transformer) { described_class }

  describe "#call" do
    let(:content) { {template_roots: [Pathname.pwd]} }

    it "answers path array with overrides prepended" do
      expect(transformer.call(content)).to eq(
        Success(template_roots: [Bundler.root.join("lib/rubysmith/templates"), Pathname.pwd])
      )
    end

    it "answers default array with no overrides" do
      expect(transformer.call(content, overrides: nil)).to eq(
        Success(template_roots: [Pathname.pwd])
      )
    end

    context "without defaults or overrides" do
      let(:content) { {} }

      it "answers empty array" do
        expect(transformer.call(content, overrides: nil)).to eq(Success({template_roots: []}))
      end
    end
  end
end
