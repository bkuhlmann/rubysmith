# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Shell do
  using Refinements::Pathname
  using Refinements::Struct
  using Infusible::Stub

  subject(:shell) { described_class.new }

  include_context "with application dependencies"

  before { Sod::Import.stub kernel:, logger: }

  after { Sod::Import.unstub :kernel, :logger }

  describe "#call" do
    let :bom_maximum do
      SPEC_ROOT.join("support/fixtures/boms/maximum.txt").each_line(chomp: true).compact
    end

    let :project_files do
      temp_dir.join("test")
              .files("**/*", flag: File::FNM_DOTMATCH)
              .reject { |path| path.fnmatch?("*git/*") && !path.fnmatch?("*git/HEAD") }
              .reject { |path| path.fnmatch? "*tags" }
              .reject { |path| path.fnmatch? "*lock" }
              .map { |path| path.relative_path_from(temp_dir).to_s }
    end

    it "prints configuration usage" do
      shell.call %w[config]
      expect(kernel).to have_received(:puts).with(/Manage configuration.+/m)
    end

    context "with minimum forced build" do
      let(:options) { %w[build --name test --min] }
      let(:files) { ["test/.ruby-version", "test/Gemfile", "test/lib/test.rb"].compact }

      it "builds minimum skeleton" do
        temp_dir.change_dir { shell.call options }

        expect(project_files).to match_array(files)
      end
    end

    context "with minimum optional build" do
      let :options do
        SPEC_ROOT.join("support/fixtures/arguments/minimum.txt").readlines chomp: true
      end

      let(:files) { ["test/.ruby-version", "test/Gemfile", "test/lib/test.rb"].compact }

      it "builds minimum skeleton" do
        temp_dir.change_dir { shell.call options }

        expect(project_files).to match_array(files)
      end
    end

    context "with maximum forced build" do
      let(:options) { %w[build --name test --max] }

      it "builds maximum skeleton" do
        temp_dir.change_dir { shell.call options }

        expect(project_files).to match_array(bom_maximum)
      end
    end

    context "with maximum optional build" do
      let :options do
        SPEC_ROOT.join("support/fixtures/arguments/maximum.txt").readlines chomp: true
      end

      it "builds maximum skeleton" do
        temp_dir.change_dir do
          shell.call options
          expect(project_files).to match_array(bom_maximum)
        end
      end
    end

    it "publishes project" do
      skip "Requires CI push authorization." if ENV.fetch("CI", false) == "true"

      version = "1.2.3"

      temp_dir.join("test").make_path.change_dir do
        `git init && git config --add remote.origin.url https://github.com/bkuhlmann/test`
        `touch test.txt && git add . && git commit -m "Added test file"`
        shell.call %W[--publish #{version}]

        expect(`git tag | tail -1`.strip).to eq(version)

        `git tag --delete #{version}`
        `git push --delete origin #{version}`
      end
    end

    it "prints version" do
      shell.call %w[--version]
      expect(kernel).to have_received(:puts).with(/Rubysmith\s\d+\.\d+\.\d+/)
    end

    it "prints help" do
      shell.call %w[--help]
      expect(kernel).to have_received(:puts).with(/Rubysmith.+USAGE.+/m)
    end
  end
end
