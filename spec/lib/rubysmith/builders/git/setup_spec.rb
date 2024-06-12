# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Git::Setup do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:git_dir) { temp_dir.join "test/.git" }

    before { temp_dir.change_dir { |path| path.join("test").make_path } }

    context "when enabled" do
      before { settings.build_git = true }

      it "builds repository" do
        temp_dir.change_dir { builder.call }
        expect(git_dir.exist?).to be(true)
      end

      it "answers true" do
        temp_dir.change_dir { expect(builder.call).to be(true) }
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build repository" do
        temp_dir.change_dir { builder.call }
        expect(git_dir.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
