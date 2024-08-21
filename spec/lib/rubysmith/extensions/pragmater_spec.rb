# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Extensions::Pragmater do
  using Refinements::Pathname

  subject(:extension) { described_class.new }

  include_context "with application dependencies"

  before { temp_dir.join("test/Gemfile").make_ancestors.touch }

  describe "#call" do
    it "logs info" do
      extension.call
      expect(logger.reread).to match(%r(🟢.+Adding frozen string literal pragmas...))
    end

    it "adds frozen string literal" do
      extension.call
      expect(temp_dir.join("test/Gemfile").read).to eq("# frozen_string_literal: true\n")
    end

    it "answers true" do
      expect(extension.call).to be(true)
    end
  end
end
