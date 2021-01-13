# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Rubocop::Formatter, :realm do
  using Refinements::Pathnames

  subject(:builder) { described_class.new default_realm, client: client }

  let(:client) { instance_spy RuboCop::CLI }

  it_behaves_like "a builder"

  describe "#call" do
    it "runs Rubocop" do
      builder.call

      expect(client).to have_received(:run).with(
        [
          "--auto-correct",
          default_realm.project_root.to_s
        ]
      )
    end
  end
end
