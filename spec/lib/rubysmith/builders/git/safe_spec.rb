# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Git::Safe do
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:safe_path) { temp_dir.join "test/.git/safe" }

  it_behaves_like "a builder"

  describe "#call" do
    context "with minimum options" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't build safe directory" do
        builder.call
        expect(safe_path.exist?).to be(false)
      end
    end

    context "with maximum options" do
      let(:test_configuration) { configuration.maximize }

      it "doesn't build ignore file" do
        builder.call
        expect(safe_path.exist?).to be(true)
      end
    end
  end
end
