# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Git::Ignore do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:ignore_path) { temp_dir.join "test", ".gitignore" }

    context "when enabled" do
      before { settings.build_git = true }

      it "builds ignore file" do
        builder.call

        expect(ignore_path.read).to eq(<<~CONTENT)
          .bundle
          tmp
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build ignore file" do
        builder.call

        expect(ignore_path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
