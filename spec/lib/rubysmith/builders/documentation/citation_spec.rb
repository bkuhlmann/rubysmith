# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Documentation::Citation do
  subject(:builder) { described_class.new configuration }

  include_context "with application container"

  let(:build_path) { temp_dir.join "test/CITATION.cff" }

  it_behaves_like "a builder"

  describe "#call" do
    context "when enabled" do
      let(:configuration) { application_configuration.minimize.with build_citation: true }

      it "builds citation" do
        builder.call

        expect(build_path.read).to eq(<<~CONTENT)
          cff-version: 1.2.0
          message: Please use the following metadata when citing this project in your work.
          title: Test
          abstract:
          version: 0.1.0
          license: Hippocratic-3.0
          date-released: 2020-01-01
          authors:
            - family-names: Smith
              given-names: Jill
              affiliation: ACME
              orcid: https://orcid.org/0000-1111-2222-3333
          keywords:
           - ruby
          repository-code: https://example.com/projects/test
          repository-artifact: https://example.com/projects/test
        CONTENT
      end
    end

    context "when disabled" do
      let(:configuration) { application_configuration.minimize }

      it "does not build configuration" do
        builder.call
        expect(build_path.exist?).to eq(false)
      end
    end
  end
end
