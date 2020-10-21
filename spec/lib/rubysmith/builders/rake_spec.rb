# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Rake, :realm do
  subject(:builder) { described_class.new realm }

  let(:rakefile_path) { temp_dir.join "test", "Rakefile" }

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "with default options" do
      let(:realm) { default_realm }

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(
          <<~CONTENT
            desc "Run code quality checks"
            task code_quality: %i[]

            task default: %i[code_quality]
          CONTENT
        )
      end
    end

    context "with only Bundler Audit" do
      let(:realm) { default_realm.with build_bundler_audit: true }

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(
          <<~CONTENT
            require "bundler/audit/task"

            Bundler::Audit::Task.new

            desc "Run code quality checks"
            task code_quality: %i[bundle:audit]

            task default: %i[code_quality]
          CONTENT
        )
      end
    end

    context "with only Bundler Leak" do
      let(:realm) { default_realm.with build_bundler_leak: true }

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(
          <<~CONTENT
            require "bundler/plumber/task"

            Bundler::Plumber::Task.new

            desc "Run code quality checks"
            task code_quality: %i[bundle:leak]

            task default: %i[code_quality]
          CONTENT
        )
      end
    end

    context "with only Git and Git Lint" do
      let(:realm) { default_realm.with build_git: true, build_git_lint: true }

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(
          <<~CONTENT
            require "git/lint/rake/setup"

            desc "Run code quality checks"
            task code_quality: %i[git_lint]

            task default: %i[code_quality]
          CONTENT
        )
      end
    end

    context "with only Reek" do
      let(:realm) { default_realm.with build_reek: true }

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(
          <<~CONTENT
            require "reek/rake/task"

            Reek::Rake::Task.new

            desc "Run code quality checks"
            task code_quality: %i[reek]

            task default: %i[code_quality]
          CONTENT
        )
      end
    end

    context "with only RSpec" do
      let(:realm) { default_realm.with build_rspec: true }

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(
          <<~CONTENT
            require "rspec/core/rake_task"

            RSpec::Core::RakeTask.new :spec

            desc "Run code quality checks"
            task code_quality: %i[]

            task default: %i[code_quality spec]
          CONTENT
        )
      end
    end

    context "with only Rubocop" do
      let(:realm) { default_realm.with build_rubocop: true }

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(
          <<~CONTENT
            require "rubocop/rake_task"

            RuboCop::RakeTask.new

            desc "Run code quality checks"
            task code_quality: %i[rubocop]

            task default: %i[code_quality]
          CONTENT
        )
      end
    end

    context "with all options" do
      let :realm do
        default_realm.with build_bundler_audit: true,
                           build_bundler_leak: true,
                           build_git: true,
                           build_git_lint: true,
                           build_reek: true,
                           build_rspec: true,
                           build_rubocop: true
      end

      let :proof do
        <<~CONTENT
          require "bundler/audit/task"
          require "bundler/plumber/task"
          require "git/lint/rake/setup"
          require "reek/rake/task"
          require "rspec/core/rake_task"
          require "rubocop/rake_task"

          Bundler::Audit::Task.new
          Bundler::Plumber::Task.new
          Reek::Rake::Task.new
          RSpec::Core::RakeTask.new :spec
          RuboCop::RakeTask.new

          desc "Run code quality checks"
          task code_quality: %i[bundle:audit bundle:leak git_lint reek rubocop]

          task default: %i[code_quality spec]
        CONTENT
      end

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(proof)
      end
    end
  end
end
