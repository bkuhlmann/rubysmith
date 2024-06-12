# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Extensions::Tocer do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:extension) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    before { temp_dir.join("test/README.md").make_ancestors.write("## Test") }

    context "with readme enabled" do
      it "adds table of contents" do
        extension.call

        expect(temp_dir.join("test/README.md").read).to eq(<<~CONTENT.strip)
          <!-- Tocer[start]: Auto-generated, don't remove. -->

          ## Table of Contents

            - [Test](#test)

          <!-- Tocer[finish]: Auto-generated, don't remove. -->

          ## Test
        CONTENT
      end

      it "answers true" do
        expect(extension.call).to be(true)
      end
    end

    context "with readme disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't delegate to client" do
        extension.call
        expect(temp_dir.join("test/README.md").read).to eq("## Test")
      end

      it "answers false" do
        expect(extension.call).to be(false)
      end
    end
  end
end
