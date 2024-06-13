# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::GitHub::Funding do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:funding_path) { temp_dir.join "test/.github/FUNDING.yml" }

    context "when enabled with all options" do
      before do
        settings.merge! settings.maximize
        builder.call
      end

      it "builds funding configuration" do
        expect(funding_path.exist?).to be(true)
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when enabled without funding" do
      before do
        settings.merge! settings.minimize.merge(build_git_hub: true)
        builder.call
      end

      it "does not build funding configuration" do
        expect(funding_path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end

    context "when disabled" do
      before do
        settings.merge! settings.minimize
        builder.call
      end

      it "does not build funding configuration" do
        expect(funding_path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
