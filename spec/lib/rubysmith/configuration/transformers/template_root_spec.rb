# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Transformers::TemplateRoot do
  include Dry::Monads[:result]

  subject(:transformer) { described_class.new }

  describe "#call" do
    let(:content) { {template_roots: [Pathname.pwd]} }

    it "answers array with custom content appended to defaults" do
      expect(transformer.call(content)).to eq(
        Success(template_roots: [Bundler.root.join("lib/rubysmith/templates"), Pathname.pwd])
      )
    end

    it "answers array without defaults" do
      transformer = described_class.new default: nil
      expect(transformer.call(content)).to eq(Success(template_roots: [Pathname.pwd]))
    end

    it "answers empty array without defaults or custom content" do
      transformer = described_class.new default: nil
      expect(transformer.call({})).to eq(Success({template_roots: []}))
    end
  end
end
