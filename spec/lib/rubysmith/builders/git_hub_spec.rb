# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::GitHub do
  subject(:builder) { described_class.new test_configuration }

  include_context "with application container"

  let(:issue_path) { temp_dir.join "test/.github/ISSUE_TEMPLATE.md" }
  let(:pull_request_path) { temp_dir.join "test/.github/PULL_REQUEST_TEMPLATE.md" }

  it_behaves_like "a builder"

  describe "#call" do
    context "when enabled" do
      let(:test_configuration) { configuration.minimize.with build_git_hub: true }

      it "builds issue template" do
        builder.call

        expect(issue_path.read).to eq(<<~CONTENT)
          ## Overview
          <!-- Required. Describe, briefly, the behavior experienced and desired. -->

          ## Screenshots/Screencasts
          <!-- Optional. Attach screenshot(s) and/or screencast(s) that demo the behavior. -->

          ## Steps to Recreate
          <!-- Required. List exact steps (numbered list) to reproduce errant behavior. -->

          ## Environment
          <!-- Required. What is your operating system, software version(s), etc. -->
        CONTENT
      end

      it "builds pull request template" do
        builder.call

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

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "does not build issue template" do
        builder.call
        expect(issue_path.exist?).to eq(false)
      end

      it "does not build pull request template" do
        builder.call
        expect(pull_request_path.exist?).to eq(false)
      end
    end
  end
end
