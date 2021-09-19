# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Git::Setup do
  using Refinements::Pathnames

  subject(:builder) { described_class.new configuration }

  include_context "with application container"

  let(:git_dir) { temp_dir.join "test", ".git" }

  it_behaves_like "a builder"

  describe "#call" do
    before do
      temp_dir.change_dir do
        temp_dir.join("test").make_path
        builder.call
      end
    end

    context "when enabled" do
      let(:configuration) { application_configuration.minimize.with build_git: true }

      it "initializes repository" do
        expect(git_dir.exist?).to eq(true)
      end
    end

    context "when disabled" do
      let(:configuration) { application_configuration.minimize }

      it "doesn't initialize repository" do
        expect(git_dir.exist?).to eq(false)
      end
    end
  end
end
