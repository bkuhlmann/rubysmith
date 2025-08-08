# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::GitHub::Template do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:issue_path) { temp_dir.join "test/.github/ISSUE_TEMPLATE/issue.md" }
    let(:pull_request_path) { temp_dir.join "test/.github/PULL_REQUEST_TEMPLATE.md" }
    let(:configuration_path) { temp_dir.join "test/.github/ISSUE_TEMPLATE/config.yml" }

    context "when enabled with all options" do
      before do
        settings.merge! settings.maximize
        builder.call
      end

      it "builds issue template" do
        expect(issue_path.exist?).to be(true)
      end

      it "builds pull request template" do
        expect(pull_request_path.exist?).to be(true)
      end

      it "builds issue configuration" do
        expect(configuration_path.read).to eq(<<~CONTENT)
          blank_issues_enabled: false
          contact_links:
            - name: Community
              url: https://undefined.io/community
              about: Please ask questions or discuss specifics here.
            - name: Security
              url: https://undefined.io/policies/security
              about: Please report security vulnerabilities here.
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before do
        settings.merge! settings.minimize
        builder.call
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
