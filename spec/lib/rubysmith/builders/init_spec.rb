# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Init do
  using Refinements::Structs
  using Refinements::Pathnames

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  # it_behaves_like "a builder"

  describe "#call" do
    let :test_configuration do
      configuration.minimize.merge project_name: "test"
    end

    it "logs debug info when project is initialized" do
      temp_dir.change_dir do
        builder.call
        expect(logger.reread).to match(/🔎.+Checked: #{temp_dir.join "test"}./)
      end
    end
  end
end
