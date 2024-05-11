# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Transformers::TemplateRoot do
  include Dry::Monads[:result]

  subject(:transformer) { described_class.new }

  describe "#call" do
    let(:attributes) { {template_roots: Pathname.pwd} }

    it "answers array with attributes path appended to default path" do
      expect(transformer.call(attributes)).to eq(
        Success(template_roots: [Bundler.root.join("lib/rubysmith/templates"), Pathname.pwd])
      )
    end

    it "answers array with paths appended to default paths" do
      attributes[:template_roots] = [Pathname("/one"), Pathname("/two")]

      expect(transformer.call(attributes)).to eq(
        Success(
          template_roots: [
            Bundler.root.join("lib/rubysmith/templates"),
            Pathname("/one"),
            Pathname("/two")
          ]
        )
      )
    end

    it "answers array without defaults" do
      transformer = described_class.new default: nil
      expect(transformer.call(attributes)).to eq(Success(template_roots: [Pathname.pwd]))
    end

    it "answers empty array without defaults or custom attributes" do
      transformer = described_class.new default: nil
      expect(transformer.call({})).to eq(Success({template_roots: []}))
    end

    it "prepends new default to existing default path" do
      result = described_class.new.call({}).bind do |attributes|
        described_class.new(default: Pathname("/test")).call attributes
      end

      expect(result).to eq(
        Success(
          template_roots: [
            Pathname("/test"),
            Bundler.root.join("lib/rubysmith/templates")
          ]
        )
      )
    end
  end
end
