# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Git::Setup do
  using Refinements::Pathnames
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:git_dir) { temp_dir.join "test", ".git" }

  it_behaves_like "a builder"

  describe "#call" do
    before do
      temp_dir.change_dir do |path|
        path.join("test").make_path
        builder.call
      end
    end

    context "when enabled" do
      let(:test_configuration) { configuration.minimize.merge build_git: true }

      it "initializes repository" do
        expect(git_dir.exist?).to be(true)
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't initialize repository" do
        expect(git_dir.exist?).to be(false)
      end
    end
  end
end
