# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Git::Ignore do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    let(:ignore_path) { temp_dir.join "test", ".gitignore" }

    it "doesn't build ignore file with minimum options" do
      settings.merge! settings.minimize
      builder.call

      expect(ignore_path.exist?).to be(false)
    end

    it "doesn't build ignore file with maximum options" do
      settings.merge! settings.maximize
      builder.call

      expect(ignore_path.read).to eq(<<~CONTENT)
        .bundle
        tmp
      CONTENT
    end
  end
end
