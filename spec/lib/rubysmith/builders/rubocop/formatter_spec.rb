# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Rubocop::Formatter do
  using Refinements::Pathnames

  subject(:builder) { described_class.new default_configuration, client: client }

  include_context "with configuration"

  let(:client) { instance_spy RuboCop::CLI }

  it_behaves_like "a builder"

  describe "#call" do
    it "runs Rubocop" do
      builder.call

      expect(client).to have_received(:run).with(
        [
          "--auto-correct",
          default_configuration.project_root.to_s
        ]
      )
    end
  end
end
