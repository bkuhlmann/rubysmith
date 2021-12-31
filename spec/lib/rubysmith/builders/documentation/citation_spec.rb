# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Documentation::Citation do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application container"

  let(:build_path) { temp_dir.join "test/CITATION.cff" }

  it_behaves_like "a builder"

  describe "#call" do
    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_citation: true }

      it "builds citation" do
        builder.call

        expect(build_path.read).to eq(<<~CONTENT)
          cff-version: 1.2.0
          message: Please use the following metadata when citing this project in your work.
          title: Test
          abstract:
          version: 0.0.0
          license: Hippocratic-3.0
          date-released: 2020-01-01
          authors:
            - family-names: Smith
              given-names: Jill
              affiliation: ACME
              orcid: https://orcid.org/0000-1111-2222-3333
          keywords:
           - ruby
          repository-code: https://www.example.com/test/source
          repository-artifact: https://www.example.com/test/download
        CONTENT
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "does not build configuration" do
        builder.call
        expect(build_path.exist?).to eq(false)
      end
    end
  end
end
