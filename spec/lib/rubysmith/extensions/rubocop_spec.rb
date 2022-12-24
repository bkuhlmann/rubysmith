# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Extensions::Rubocop do
  using Refinements::Pathnames

  subject(:builder) { described_class.new configuration.minimize, client: }

  include_context "with application dependencies"

  let(:client) { instance_spy RuboCop::CLI }

  before { temp_dir.join("test").make_path }

  describe ".call" do
    it "answers configuration" do
      expect(described_class.call(configuration, client:)).to be_a(
        Rubysmith::Configuration::Content
      )
    end
  end

  describe "#call" do
    it "runs RuboCop" do
      builder.call

      expect(client).to have_received(:run).with(
        ["--autocorrect-all", configuration.project_root.to_s]
      )
    end
  end
end
