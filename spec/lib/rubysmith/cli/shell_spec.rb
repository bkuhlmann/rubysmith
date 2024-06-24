# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Shell do
  using Refinements::Pathname
  using Refinements::Struct
  using Refinements::StringIO

  subject(:shell) { described_class.new }

  include_context "with application dependencies"

  before { Sod::Container.stub! logger:, io: }

  after { Sod::Container.restore }

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
      expect(io.reread).to match(/Manage configuration.+/m)
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

    it "prints version" do
      shell.call %w[--version]
      expect(io.reread).to match(/Rubysmith\s\d+\.\d+\.\d+/)
    end

    it "prints help" do
      shell.call %w[--help]
      expect(io.reread).to match(/Rubysmith.+USAGE.+/m)
    end
  end
end
