# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Docker::Compose do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test/compose.yml" }

    context "when enabled" do
      before { settings.build_docker = true }

      it "uses project name for image" do
        builder.call

        expect(path.read).to eq(
          <<~CONTENT
            name: "test"

            services:
              web:
                init: true
                build:
                  context: .
                ports:
                  - "2300:2300"
                restart: unless-stopped
                deploy:
                  resources:
                    limits:
                      memory: 1G
                      cpus: "1.0"
          CONTENT
        )
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    context "when disabled" do
      before { settings.with! settings.minimize }

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
