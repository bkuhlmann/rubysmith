# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Documentation::Citation do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    let(:build_path) { temp_dir.join "test/CITATION.cff" }

    it "builds citation when enabled" do
      settings.merge! settings.minimize.merge(
        build_citation: true,
        citation_affiliation: "ACME",
        citation_orcid: "0000-1111-2222-3333"
      )

      builder.call

      expect(build_path.read).to eq(<<~CONTENT)
        cff-version: 1.2.0
        message: Please use the following metadata when citing this project in your work.
        title: Test
        abstract:
        version: 0.0.0
        license: Hippocratic-2.1
        date-released: 2020-01-01
        authors:
          - family-names: Smith
            given-names: Jill
            affiliation: ACME
            orcid: https://orcid.org/0000-1111-2222-3333
        keywords:
         - ruby
        repository-code: https://acme.io/test/source
        repository-artifact: https://acme.io/test/download
        url: https://acme.io/test
      CONTENT
    end

    it "does not build configuration when disabled" do
      settings.merge! settings.minimize
      builder.call

      expect(build_path.exist?).to be(false)
    end
  end
end
