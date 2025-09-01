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

  describe "#call" do
    let(:project_dir) { temp_dir.join "test" }
    let(:commit) { project_dir.change_dir { `git log --pretty=format:%s%n%n%b -1` } }

    context "when enabled" do
      before do
        settings.with! settings.minimize.with(build_git: true)

        project_dir.mkpath.change_dir do |path|
          `git init`
          `git config user.name "#{settings.author_name}"`
          `git config user.email "#{settings.author_email}"`
          path.join("test.txt").touch
        end
      end

      it "creates commit" do
        temp_dir.change_dir { builder.call }

        expect(commit).to eq(<<~BODY)
          Added project skeleton

          Generated with link:https://example.com[Test] 0.0.0.
        BODY
      end

      it "answers true" do
        temp_dir.change_dir { expect(builder.call).to be(true) }
      end
    end

    context "when disabled" do
      before { settings.with! settings.minimize }

      it "doesn't create commit" do
        project_dir.mkpath.change_dir do
          `git init`
          builder.call
        end

        expect(commit).to eq("")
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
