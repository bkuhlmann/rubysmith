# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Docker::Build do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/bin/docker/build" }

    context "when enabled" do
      before { settings.build_docker = true }

      it "uses project name for image" do
        builder.call
        expect(path.read).to include("test:latest")
      end

      it "updates file permissions" do
        builder.call
        expect(path.stat.mode).to eq(33261)
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
