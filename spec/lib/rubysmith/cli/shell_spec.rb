# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Shell, :runcom do
  using Refinements::Pathnames

  subject(:shell) { described_class.new processors: processors }

  let :processors do
    {
      config: Rubysmith::CLI::Processors::Config.new(
        configuration: runcom_configuration,
        kernel: kernel
      ),
      build_minimum: Rubysmith::CLI::Processors::Build.with_minimum,
      build_maximum: Rubysmith::CLI::Processors::Build.new
    }
  end

  let(:kernel) { class_spy Kernel }

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
      expect(kernel).to have_received(:system).with(/\$EDITOR\s.+configuration.yml/)
    end

    it "views configuration" do
      shell.call %w[--config view]
      expect(kernel).to have_received(:system).with(/cat\s.+configuration.yml/)
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
          --no-bundler-audit
          --no-bundler-leak
          --no-console
          --no-documentation
          --no-git
          --no-git-lint
          --no-guard
          --no-pry
          --no-reek
          --no-refinements
          --no-rspec
          --no-rubocop
          --no-ruby_critic
          --no-setup
          --no-simple_cov
        ]
      end

      let :files do
        [
          "test/.ruby-version",
          "test/Gemfile",
          "test/Gemfile.lock",
          "test/Rakefile",
          "test/lib/test.rb"
        ]
      end

      it "builds minimum skeleton" do
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
          --bundler-audit
          --console
          --documentation
          --git
          --git-lint
          --guard
          --pry
          --reek
          --rspec
          --rubocop
          --ruby_critic
          --setup
          --simple_cov
        ]
      end

      let :files do
        [
          "test/.git/COMMIT_EDITMSG",
          "test/.git/MERGE_RR",
          "test/.reek.yml",
          "test/.rubocop.yml",
          "test/.rubycritic.yml",
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
        next if ENV["CI"] == "true" # FIX: Needs a global Git configuration.

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
