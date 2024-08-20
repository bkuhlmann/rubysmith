# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::DevContainer::Configuration do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/.devcontainer/devcontainer.json" }

    context "when enabled" do
      before { settings.build_devcontainer = true }

      it "includes project name" do
        builder.call
        expect(path.read).to include(%("name": "test"))
      end

      it "includes post create command when setup is enabled" do
        settings.build_setup = true
        builder.call

        expect(path.read).to include(%("postCreateCommand": "bin/setup"))
      end

      it "excludes post create command when setup is disabled" do
        settings.build_setup = false
        builder.call

        expect(path.read).not_to include(%("postCreateCommand": "bin/setup"))
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
