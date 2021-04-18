# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Pragma do
  using Refinements::Pathnames

  subject(:builder) { described_class.new default_configuration }

  include_context "with configuration"

  let(:test_path) { temp_dir.join "test", "test.rb" }

  it_behaves_like "a builder"

  describe "#call" do
    it "adds pragmas" do
      test_path.make_ancestors.touch
      builder.call

      expect(test_path.read).to eq("# frozen_string_literal: true\n")
    end
  end
end
