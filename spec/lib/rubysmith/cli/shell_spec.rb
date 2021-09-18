# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Shell do
  using Refinements::Pathnames

  subject(:shell) { described_class.new }

  include_context "with application container"

  describe "#call" do
    let :project_files do
      temp_dir.join("test")
              .files("**/*", flag: File::FNM_DOTMATCH)
              .reject { |path| path.fnmatch? "*.git/[^COMMIT]*" }
              .reject { |path| path.fnmatch? "*rubocop-https*" }
              .map { |path| path.relative_path_from(temp_dir).to_s }
    end

    it "edits configuration" do
      shell.call %w[--config edit]
      expect(kernel).to have_received(:system).with(include("EDITOR"))
    end

    it "views configuration" do
      shell.call %w[--config view]
      expect(kernel).to have_received(:system).with(include("cat"))
    end

    context "with minimum forced build" do
      let :options do
        %w[
          --build
          test
          --min
        ]
      end

      let :files do
        [
          "test/.ruby-version",
          "test/Gemfile",
          "test/Gemfile.lock",
          "test/lib/test.rb"
        ]
      end

      it "builds minimum skeleton" do
        pending "Requires Bundler working properly in CI." if ENV["CI"] == "true"

        temp_dir.change_dir do
          Bundler.definition true
          Bundler.with_unbundled_env { shell.call options }
        end

        expect(project_files).to contain_exactly(*files)
      end
    end

    context "with minimum optional build" do
      let :options do
        %w[
          --build
          test
          --no-amazing_print
          --no-bundler-leak
          --no-circle_ci
          --no-console
          --no-debug
          --no-documentation
          --no-git
          --no-git_hub
          --no-git-lint
          --no-guard
          --no-rake
          --no-reek
          --no-refinements
          --no-rspec
          --no-rubocop
          --no-setup
          --no-simple_cov
          --no-zeitwerk
        ]
      end

      let :files do
        [
          "test/.ruby-version",
          "test/Gemfile",
          "test/Gemfile.lock",
          "test/lib/test.rb"
        ]
      end

      it "builds minimum skeleton" do
        pending "Requires Bundler working properly in CI." if ENV["CI"] == "true"

        temp_dir.change_dir do
          Bundler.definition true
          Bundler.with_unbundled_env { shell.call options }
        end

        expect(project_files).to contain_exactly(*files)
      end
    end

    context "with maximum build" do
      let :options do
        %w[
          --build
          test
          --amazing_print
          --bundler-leak
          --circle_ci
          --console
          --debug
          --documentation
          --git
          --git_hub
          --git-lint
          --guard
          --rake
          --reek
          --refinements
          --rspec
          --rubocop
          --setup
          --simple_cov
          --zeitwerk
        ]
      end

      let :files do
        [
          "test/.circleci/config.yml",
          "test/.github/ISSUE_TEMPLATE.md",
          "test/.github/PULL_REQUEST_TEMPLATE.md",
          "test/.git/COMMIT_EDITMSG",
          "test/.git/MERGE_RR",
          "test/.reek.yml",
          "test/.rubocop.yml",
          "test/.ruby-version",
          "test/Gemfile",
          "test/Gemfile.lock",
          "test/CHANGES.md",
          "test/CODE_OF_CONDUCT.md",
          "test/CONTRIBUTING.md",
          "test/LICENSE.md",
          "test/Guardfile",
          "test/Rakefile",
          "test/README.md",
          "test/bin/console",
          "test/bin/guard",
          "test/bin/rubocop",
          "test/bin/setup",
          "test/lib/test.rb",
          "test/spec/support/shared_contexts/temp_dir.rb",
          "test/spec/spec_helper.rb",
          "test/tags"
        ]
      end

      it "builds maximum skeleton" do
        pending "Requires Bundler working properly in CI." if ENV["CI"] == "true"

        temp_dir.change_dir do
          Bundler.definition true
          Bundler.with_unbundled_env { shell.call options }
        end

        expect(project_files).to contain_exactly(*files)
      end
    end

    it "prints version" do
      expectation = proc { shell.call %w[--version] }
      expect(&expectation).to output(match_cli_version).to_stdout
    end

    it "prints help (usage)" do
      expectation = proc { shell.call %w[--help] }
      expect(&expectation).to output(/Rubysmith.+USAGE.+BUILD OPTIONS/m).to_stdout
    end

    it "prints usage when no options are given" do
      expectation = proc { shell.call }
      expect(&expectation).to output(/Rubysmith.+USAGE.+BUILD OPTIONS.+/m).to_stdout
    end

    it "prints error with invalid option" do
      expectation = proc { shell.call %w[--bogus] }
      expect(&expectation).to output(/invalid option.+bogus/).to_stdout
    end
  end
end
