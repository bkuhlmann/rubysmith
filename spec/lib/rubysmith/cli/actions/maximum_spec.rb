# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Actions::Maximum do
  subject(:action) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    it "answers enables build options" do
      action.call
      result = settings.to_h.select { |key, _| key.start_with? "build_" }

      expect(result).to eq(
        **YAML.load_file(SPEC_ROOT.join("support/fixtures/attributes/maximum.yml"))
      )
    end
  end
end
