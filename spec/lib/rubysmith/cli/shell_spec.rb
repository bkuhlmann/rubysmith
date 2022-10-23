# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Shell do
  using Refinements::Pathnames
  using Infusible::Stub

  subject(:shell) { described_class.new }

  include_context "with application dependencies"

  before { Rubysmith::CLI::Actions::Import.stub kernel:, logger: }

  after { Rubysmith::CLI::Actions::Import.unstub :kernel, :logger }

  describe "#call" do
    let :project_files do
      temp_dir.join("test")
              .files("**/*", flag: File::FNM_DOTMATCH)
              .reject { |path| path.fnmatch?("*git/*") && !path.fnmatch?("*git/HEAD") }
              .reject { |path| path.fnmatch? "*tags" }
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
          ("test/Gemfile.lock" unless ENV.fetch("CI", false) == "true"),
          "test/lib/test.rb"
        ].compact
      end

      it "builds minimum skeleton" do
        temp_dir.change_dir { Bundler.with_unbundled_env { shell.call options } }

        expect(project_files).to contain_exactly(*files)
      end
    end

    context "with minimum optional build" do
      let :options do
        %w[
          --build
          test
          --no-amazing_print
          --no-caliber
          --no-circle_ci
          --no-citation
          --no-community
          --no-conduct
          --no-console
          --no-contributions
          --no-debug
          --no-funding
          --no-git
          --no-git_hub
          --no-git-lint
          --no-guard
          --no-license
          --no-rake
          --no-readme
          --no-reek
          --no-refinements
          --no-rspec
          --no-setup
          --no-security
          --no-simple_cov
          --no-versions
          --no-zeitwerk
        ]
      end

      let :files do
        [
          "test/.ruby-version",
          "test/Gemfile",
          ("test/Gemfile.lock" unless ENV.fetch("CI", false) == "true"),
          "test/lib/test.rb"
        ].compact
      end

      it "builds minimum skeleton" do
        temp_dir.change_dir { Bundler.with_unbundled_env { shell.call options } }

        expect(project_files).to contain_exactly(*files)
      end
    end

    context "with maximum forced build" do
      let :options do
        %w[
          --build
          test
          --max
        ]
      end

      let :files do
        [
          "test/.circleci/config.yml",
          "test/.git/HEAD",
          "test/.github/FUNDING.yml",
          "test/.github/ISSUE_TEMPLATE.md",
          "test/.github/PULL_REQUEST_TEMPLATE.md",
          "test/.gitignore",
          "test/.reek.yml",
          "test/.rubocop.yml",
          "test/.ruby-version",
          "test/bin/console",
          "test/bin/guard",
          "test/bin/rubocop",
          "test/bin/setup",
          "test/CITATION.cff",
          "test/Gemfile",
          ("test/Gemfile.lock" unless ENV.fetch("CI", false) == "true"),
          "test/Guardfile",
          "test/lib/test.rb",
          "test/LICENSE.adoc",
          "test/Rakefile",
          "test/README.adoc",
          "test/spec/spec_helper.rb",
          "test/spec/support/shared_contexts/temp_dir.rb",
          "test/VERSIONS.adoc"
        ].compact
      end

      it "builds maximum skeleton" do
        temp_dir.change_dir { Bundler.with_unbundled_env { shell.call options } }

        expect(project_files).to contain_exactly(*files)
      end
    end

    context "with maximum optional build" do
      let :options do
        %w[
          --build
          test
          --amazing_print
          --caliber
          --circle_ci
          --citation
          --community
          --conduct
          --console
          --contributions
          --debug
          --funding
          --git
          --git_hub
          --git-lint
          --guard
          --license
          --rake
          --readme
          --reek
          --refinements
          --rspec
          --setup
          --security
          --simple_cov
          --versions
          --zeitwerk
        ]
      end

      let :files do
        [
          "test/.circleci/config.yml",
          "test/.git/HEAD",
          "test/.github/FUNDING.yml",
          "test/.github/ISSUE_TEMPLATE.md",
          "test/.github/PULL_REQUEST_TEMPLATE.md",
          "test/.gitignore",
          "test/.reek.yml",
          "test/.rubocop.yml",
          "test/.ruby-version",
          "test/bin/console",
          "test/bin/guard",
          "test/bin/rubocop",
          "test/bin/setup",
          "test/CITATION.cff",
          "test/Gemfile",
          ("test/Gemfile.lock" unless ENV.fetch("CI", false) == "true"),
          "test/Guardfile",
          "test/lib/test.rb",
          "test/LICENSE.adoc",
          "test/Rakefile",
          "test/README.adoc",
          "test/spec/spec_helper.rb",
          "test/spec/support/shared_contexts/temp_dir.rb",
          "test/VERSIONS.adoc"
        ].compact
      end

      it "builds maximum skeleton" do
        temp_dir.change_dir do
          Bundler.with_unbundled_env { shell.call options }
          expect(project_files).to contain_exactly(*files)
        end
      end
    end

    it "publishes project" do
      version = "1.2.3"
      temp_dir.change_dir { `git clone https://github.com/bkuhlmann/test` }

      temp_dir.join("test").change_dir do
        `touch test.txt && git add . && git commit -m "Added test file"`
        shell.call %W[--publish #{version}]

        expect(`git tag | tail -1`.strip).to eq(version)

        `git tag --delete #{version}`
        `git push --delete origin #{version}`
      end
    end

    it "prints version" do
      shell.call %w[--version]
      expect(logger.reread).to match(/Rubysmith\s\d+\.\d+\.\d+/)
    end

    it "prints help (usage)" do
      shell.call %w[--help]
      expect(logger.reread).to match(/Rubysmith.+USAGE.+BUILD OPTIONS/m)
    end

    it "prints usage when no options are given" do
      shell.call
      expect(logger.reread).to match(/Rubysmith.+USAGE.+BUILD OPTIONS.+/m)
    end

    it "prints error with invalid option" do
      shell.call %w[--bogus]
      expect(logger.reread).to match(/invalid option.+bogus/)
    end
  end
end
