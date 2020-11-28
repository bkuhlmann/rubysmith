# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Git::Commit, :realm do
  using Refinements::Pathnames

  subject(:builder) { described_class.new realm }

  let(:project_dir) { temp_dir.join "test" }
  let(:commit) { Dir.chdir(project_dir) { `git log --pretty=format:%s%n%b -1` } }

  it_behaves_like "a builder"

  describe "#call" do
    before do
      Dir.chdir temp_dir do
        project_dir.mkdir
        Dir.chdir project_dir do
          `git init`
          `git config user.name "#{realm.author_name}"`
          `git config user.email "#{realm.author_email}"`
        end
        project_dir.join("test.txt").touch
        builder.call
      end
    end

    context "when enabled" do
      let(:realm) { default_realm.with build_git: true }

      it "creates commit" do
        expect(commit).to match(
          /Added project skeleton.+Generated with.+Rubysmith.+\d+\.\d+\.\d+\./m
        )
      end
    end

    context "when disabled" do
      let(:realm) { default_realm.with build_git: false }

      it "doesn't create commit" do
        expect(commit).to eq("")
      end
    end
  end
end
