# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Git::Setup, :realm do
  subject(:builder) { described_class.new realm }

  let(:git_dir) { temp_dir.join "test", ".git" }

  it_behaves_like "a builder"

  describe "#call" do
    before do
      Dir.chdir temp_dir do
        temp_dir.join("test").mkdir
        builder.call
      end
    end

    context "when enabled" do
      let(:realm) { default_realm.with build_git: true }

      it "initializes repository" do
        expect(git_dir.exist?).to eq(true)
      end
    end

    context "when disabled" do
      let(:realm) { default_realm.with build_git: false }

      it "doesn't initialize repository" do
        expect(git_dir.exist?).to eq(false)
      end
    end
  end
end
