# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Extensions::Pragmater do
  using Refinements::Pathname

  subject(:extension) { described_class.new configuration, client: }

  include_context "with application dependencies"

  let(:client) { instance_spy Pragmater::Inserter }

  before { temp_dir.join("test/Gemfile").make_ancestors.touch }

  describe ".call" do
    it "answers configuration" do
      expect(described_class.call(configuration, client:)).to be_a(Rubysmith::Configuration::Model)
    end
  end

  describe "#call" do
    before { extension.call }

    it "delegates to client" do
      expect(client).to have_received(:call).with(
        Pragmater::Configuration::Model[
          comments: ["# frozen_string_literal: true"],
          patterns: %w[**/*.rake **/*.rb *.gemspec exe/* bin/* config.ru *file]
        ]
      )
    end

    it "adds frozen string literal" do
      described_class.new(configuration).call
      expect(temp_dir.join("test/Gemfile").read).to eq("# frozen_string_literal: true\n")
    end

    it "answers configuration" do
      expect(extension.call).to eq(configuration)
    end
  end
end
