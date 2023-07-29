# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Configuration::Transformers::TemplateRoot do
  include Dry::Monads[:result]

  subject(:transformer) { described_class.new }

  describe "#call" do
    let(:content) { {template_roots: Pathname.pwd} }

    it "answers array with content path appended to default path" do
      expect(transformer.call(content)).to eq(
        Success(template_roots: [Bundler.root.join("lib/rubysmith/templates"), Pathname.pwd])
      )
    end

    it "answers array with content paths appended to default paths" do
      content = {template_roots: [Pathname("/one"), Pathname("/two")]}

      expect(transformer.call(content)).to eq(
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
      expect(transformer.call(content)).to eq(Success(template_roots: [Pathname.pwd]))
    end

    it "answers empty array without defaults or custom content" do
      transformer = described_class.new default: nil
      expect(transformer.call({})).to eq(Success({template_roots: []}))
    end

    it "prepends new default to existing default path" do
      result = described_class.new.call({}).bind do |content|
        described_class.new(default: Pathname("/test")).call content
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
