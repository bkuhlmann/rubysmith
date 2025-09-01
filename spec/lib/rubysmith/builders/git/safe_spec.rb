# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Git::Safe do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/.git/safe" }

    context "when enabled" do
      before { settings.build_git = true }

      it "builds path" do
        builder.call
        expect(path.exist?).to be(true)
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.with! settings.minimize }

      it "doesn't build path" do
        builder.call
        expect(path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
