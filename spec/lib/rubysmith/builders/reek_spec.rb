# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Reek do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/.reek.yml" }

    context "when enabled" do
      before { settings.merge! settings.minimize.merge(build_reek: true) }

      it "builds file" do
        builder.call

        expect(path.read).to eq(<<~CONTENT)
          exclude_paths:
            - tmp
            - vendor

          detectors:
            LongParameterList:
              enabled: false
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
