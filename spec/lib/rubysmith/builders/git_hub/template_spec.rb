# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::GitHub::Template do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:funding_path) { temp_dir.join "test/.github/FUNDING.yml" }
    let(:issue_path) { temp_dir.join "test/.github/ISSUE_TEMPLATE.md" }
    let(:pull_request_path) { temp_dir.join "test/.github/PULL_REQUEST_TEMPLATE.md" }

    context "when enabled with all options" do
      before do
        settings.merge! settings.maximize
        builder.call
      end

      it "builds funding configuration" do
        expect(funding_path.exist?).to be(true)
      end

      it "builds issue template" do
        expect(issue_path.exist?).to be(true)
      end

      it "builds pull request template" do
        expect(pull_request_path.exist?).to be(true)
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

      it "builds issue template" do
        expect(issue_path.read).to eq(<<~CONTENT)
          ## Why
          <!-- Required. Describe, briefly, why this issue is important. -->

          ## How
          <!-- Optional. List exact steps (numbered) to implement or reproduce behavior. Screen shots/casts are welcome. -->

          ## Notes
          <!-- Optional. Provide additional details (i.e operating system, software version(s), stack dump, etc.) -->
        CONTENT
      end

      it "builds pull request template" do
        expect(pull_request_path.read).to eq(<<~CONTENT)
          ## Overview
          <!-- Required. Why is this important/necessary and what is the overarching architecture. -->

          ## Screenshots/Screencasts
          <!-- Optional. Provide supporting image/video. -->

          ## Details
          <!-- Optional. List the key features/highlights as bullet points. -->
        CONTENT
      end
    end

    context "with funding enabled only" do
      before do
        settings.merge! settings.minimize.merge(build_funding: true)
        builder.call
      end

      it "builds funding configuration" do
        expect(funding_path.read).to eq("github: [jsmith]\n")
      end

      it "does not build issue template" do
        expect(issue_path.exist?).to be(false)
      end

      it "does not build pull request template" do
        expect(pull_request_path.exist?).to be(false)
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

      it "does not build issue template" do
        expect(issue_path.exist?).to be(false)
      end

      it "does not build pull request template" do
        expect(pull_request_path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
