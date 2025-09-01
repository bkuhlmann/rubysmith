# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Extensions::Tocer do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:extension) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    before { temp_dir.join("test/README.md").make_ancestors.write("## Test") }

    context "with readme and Markdown enabled" do
      before { settings.with! build_readme: true, documentation_format: "md" }

      it "logs info" do
        extension.call
        expect(logger.reread).to match(%r(🟢.+Adding table of contents...))
      end

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

    context "with readme enabled and non-Markdown format" do
      before { settings.with! build_readme: true, documentation_format: "adoc" }

      it "doesn't log anything" do
        extension.call
        expect(logger.reread).to eq("")
      end

      it "doesn't delegate to client" do
        extension.call
        expect(temp_dir.join("test/README.md").read).to eq("## Test")
      end

      it "answers false" do
        expect(extension.call).to be(false)
      end
    end

    context "with readme disabled" do
      before { settings.with! settings.minimize }

      it "doesn't log anything" do
        extension.call
        expect(logger.reread).to eq("")
      end

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
