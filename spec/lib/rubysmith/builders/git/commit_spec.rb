# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Git::Commit do
  using Refinements::Pathname
  using Refinements::Struct

  subject(:builder) { described_class.new specification: }

  include_context "with application dependencies"

  let :specification do
    instance_double Spek::Presenter,
                    label: "Test",
                    homepage_url: "https://example.com",
                    version: "0.0.0"
  end

  it_behaves_like "a builder"

  describe "#call" do
    let(:project_dir) { temp_dir.join "test" }
    let(:commit) { project_dir.change_dir { `git log --pretty=format:%s%n%n%b -1` } }

    it "creates commit when enabled" do
      settings.merge! settings.minimize.merge(build_git: true)

      project_dir.make_path.change_dir do |path|
        `git init`
        `git config user.name "#{settings.author_name}"`
        `git config user.email "#{settings.author_email}"`
        path.join("test.txt").touch
      end

      temp_dir.change_dir { builder.call }

      expect(commit).to eq(<<~BODY)
        Added project skeleton

        Generated with link:https://example.com[Test] 0.0.0.
      BODY
    end

    it "doesn't create commit when disabled" do
      settings.merge! settings.minimize

      project_dir.make_path.change_dir do
        `git init`
        builder.call
      end

      expect(commit).to eq("")
    end
  end
end
