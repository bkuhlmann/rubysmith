# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Actions::Minimum do
  subject(:action) { described_class.new inputs: }

  let(:inputs) { configuration.dup }

  include_context "with application dependencies"

  describe "#call" do
    it "answers disables build options" do
      action.call
      result = inputs.to_h.select { |key, _| key.start_with? "build_" }

      expect(result).to eq(
        **YAML.load_file(SPEC_ROOT.join("support/fixtures/attributes/minimum.yml"))
      )
    end
  end
end
