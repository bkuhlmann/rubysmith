# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Init do
  using Refinements::Pathname

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "logs debug info when project is initialized" do
      settings.project_name = "test"

      temp_dir.change_dir do
        builder.call
        expect(logger.reread).to match(/🔎.+Checked: #{temp_dir.join "test"}./)
      end
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
