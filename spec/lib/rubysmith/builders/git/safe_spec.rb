# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Git::Safe do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    let(:safe_path) { temp_dir.join "test/.git/safe" }

    it "doesn't build safe directory with minimum options" do
      settings.merge! settings.minimize
      builder.call

      expect(safe_path.exist?).to be(false)
    end

    it "doesn't build ignore file with maximum options" do
      settings.merge! settings.maximize
      builder.call

      expect(safe_path.exist?).to be(true)
    end
  end
end
