# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Git::Ignore do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application container"

  let(:ignore_path) { temp_dir.join "test", ".gitignore" }

  it_behaves_like "a builder"

  describe "#call" do
    context "with minimum options" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't build ignore file" do
        builder.call
        expect(ignore_path.exist?).to eq(false)
      end
    end

    context "with Rubocop only" do
      let(:test_configuration) { configuration.minimize.merge build_git: true, build_rubocop: true }

      it "doesn't build ignore file" do
        builder.call

        expect(ignore_path.read).to eq(<<~CONTENT)
          .bundle
          .rubocop-http*
          tmp
        CONTENT
      end
    end

    context "with YARD only" do
      let(:test_configuration) { configuration.minimize.merge build_git: true, build_yard: true }

      it "doesn't build ignore file" do
        builder.call

        expect(ignore_path.read).to eq(<<~CONTENT)
          .bundle
          .yardoc
          doc/yard
          tmp
        CONTENT
      end
    end

    context "with maximum options" do
      let(:test_configuration) { configuration.maximize }

      it "doesn't build ignore file" do
        builder.call

        expect(ignore_path.read).to eq(<<~CONTENT)
          .bundle
          .rubocop-http*
          .yardoc
          doc/yard
          tmp
        CONTENT
      end
    end
  end
end
