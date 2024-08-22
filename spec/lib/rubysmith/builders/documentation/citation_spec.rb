# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Documentation::Citation do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/CITATION.cff" }

    context "when enabled" do
      before { settings.merge! settings.minimize.merge(build_citation: true) }

      it "builds file with defaults" do
        builder.call

        expect(path.read).to eq(<<~CONTENT)
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
              affiliation: %<organization_label>s
              orcid: https://orcid.org/
          keywords:
           - ruby
          repository-code: https://github.com/undefined/test
          repository-artifact: https://rubygems.org/gems/test
          url: https://undefined.io/projects/test
        CONTENT
      end

      it "builds file with custom affiliation and ORCID" do
        settings.merge! citation_affiliation: "ACME", citation_orcid: "0000-1111-2222-3333"
        builder.call

        expect(path.read).to eq(<<~CONTENT)
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
          repository-code: https://github.com/undefined/test
          repository-artifact: https://rubygems.org/gems/test
          url: https://undefined.io/projects/test
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
