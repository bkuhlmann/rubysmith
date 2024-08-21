# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Extensions::Rubocop do
  using Refinements::Pathname

  subject(:extension) { described_class.new client: }

  include_context "with application dependencies"

  let(:client) { instance_spy RuboCop::CLI }

  describe "#call" do
    before { temp_dir.join("test").make_path }

    it "logs info" do
      extension.call
      expect(logger.reread).to match(%r(🟢.+Running RuboCop autocorrect...))
    end

    it "runs RuboCop" do
      extension.call

      expect(client).to have_received(:run).with(
        ["--autocorrect-all", settings.project_root.to_s]
      )
    end

    it "answers true" do
      expect(extension.call).to be(true)
    end
  end
end
