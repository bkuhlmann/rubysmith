# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Rake do
  using Refinements::Structs

  subject(:builder) { described_class.new test_configuration }

  include_context "with application container"

  let(:rakefile_path) { temp_dir.join "test", "Rakefile" }

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    context "when enabled with default options" do
      let(:test_configuration) { configuration.minimize.merge build_rake: true }

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(<<~CONTENT)
          require "bundler/setup"

          desc "Run code quality checks"
          task code_quality: %i[]

          task default: %i[code_quality]
        CONTENT
      end
    end

    context "when enabled with only Bundler Leak" do
      let :test_configuration do
        configuration.minimize.merge build_rake: true, build_bundler_leak: true
      end

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(<<~CONTENT)
          require "bundler/setup"
          require "bundler/plumber/task"

          Bundler::Plumber::Task.new

          desc "Run code quality checks"
          task code_quality: %i[bundle:leak]

          task default: %i[code_quality]
        CONTENT
      end
    end

    context "when enabled with only Git and Git Lint" do
      let :test_configuration do
        configuration.minimize.merge build_rake: true, build_git: true, build_git_lint: true
      end

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(<<~CONTENT)
          require "bundler/setup"
          require "git/lint/rake/setup"

          desc "Run code quality checks"
          task code_quality: %i[git_lint]

          task default: %i[code_quality]
        CONTENT
      end
    end

    context "when enabled with only Reek" do
      let(:test_configuration) { configuration.minimize.merge build_rake: true, build_reek: true }

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(<<~CONTENT)
          require "bundler/setup"
          require "reek/rake/task"

          Reek::Rake::Task.new

          desc "Run code quality checks"
          task code_quality: %i[reek]

          task default: %i[code_quality]
        CONTENT
      end
    end

    context "when enabled with only RSpec" do
      let(:test_configuration) { configuration.minimize.merge build_rake: true, build_rspec: true }

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(<<~CONTENT)
          require "bundler/setup"
          require "rspec/core/rake_task"

          RSpec::Core::RakeTask.new :spec

          desc "Run code quality checks"
          task code_quality: %i[]

          task default: %i[code_quality spec]
        CONTENT
      end
    end

    context "when enabled with only RuboCop" do
      let(:test_configuration) do
        configuration.minimize.merge build_rake: true, build_rubocop: true
      end

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(<<~CONTENT)
          require "bundler/setup"
          require "rubocop/rake_task"

          RuboCop::RakeTask.new

          desc "Run code quality checks"
          task code_quality: %i[rubocop]

          task default: %i[code_quality]
        CONTENT
      end
    end

    context "when enabled with all options" do
      let(:test_configuration) { configuration.maximize }

      let :proof do
        <<~CONTENT
          require "bundler/setup"
          require "bundler/plumber/task"
          require "git/lint/rake/setup"
          require "reek/rake/task"
          require "rspec/core/rake_task"
          require "rubocop/rake_task"

          Bundler::Plumber::Task.new
          Reek::Rake::Task.new
          RSpec::Core::RakeTask.new :spec
          RuboCop::RakeTask.new

          desc "Run code quality checks"
          task code_quality: %i[bundle:leak git_lint reek rubocop]

          task default: %i[code_quality spec]
        CONTENT
      end

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(proof)
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "builds Rakefile" do
        expect(rakefile_path.exist?).to eq(false)
      end
    end
  end
end
