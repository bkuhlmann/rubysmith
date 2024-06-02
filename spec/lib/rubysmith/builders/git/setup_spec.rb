# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Git::Setup do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    let(:git_dir) { temp_dir.join "test", ".git" }

    before { temp_dir.change_dir { |path| path.join("test").make_path } }

    it "initializes repository when enabled" do
      settings.merge! settings.minimize.merge(build_git: true)
      temp_dir.change_dir { builder.call }

      expect(git_dir.exist?).to be(true)
    end

    it "doesn't initialize repository when disabled" do
      settings.merge! settings.minimize
      temp_dir.change_dir { builder.call }

      expect(git_dir.exist?).to be(false)
    end
  end
end
