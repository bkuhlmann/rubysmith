# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Reek do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    let(:settings_path) { temp_dir.join "test", ".reek.yml" }

    it "builds configuration when enabled" do
      settings.merge! settings.minimize.merge(build_reek: true)
      builder.call

      expect(settings_path.read).to eq(<<~CONTENT)
        exclude_paths:
          - tmp
          - vendor

        detectors:
          LongParameterList:
            enabled: false
      CONTENT
    end

    it "doesn't build configuration when disabled" do
      settings.merge! settings.minimize
      builder.call

      expect(settings_path.exist?).to be(false)
    end
  end
end
