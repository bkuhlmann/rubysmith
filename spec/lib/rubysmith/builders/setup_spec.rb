# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Setup do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:build_path) { temp_dir.join "test", "bin", "setup" }

  it_behaves_like "a builder"

  describe "#call" do
    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_setup: true }

      it "builds setup script without Pry support" do
        builder.call

        expect(build_path.read).to eq(<<~CONTENT)
          #! /usr/bin/env bash

          set -o nounset
          set -o errexit
          set -o pipefail
          IFS=$'\\n\\t'

          bundle install
        CONTENT
      end

      it "updates script permissions" do
        builder.call
        expect(build_path.stat.mode).to eq(33261)
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "does not build setup script" do
        builder.call
        expect(build_path.exist?).to be(false)
      end
    end
  end
end
