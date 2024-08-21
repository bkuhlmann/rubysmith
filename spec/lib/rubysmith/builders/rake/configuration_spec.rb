# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Rake::Configuration do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:path) { temp_dir.join "test", "Rakefile" }

    context "when enabled" do
      before { settings.merge! settings.minimize.merge(build_rake: true) }

      it "builds file" do
        builder.call

        expect(path.read).to eq(<<~CONTENT)
          require "bundler/setup"

          desc "Run code quality checks"
          task quality: %i[]

          task default: %i[quality]
        CONTENT
      end

      it "answers true" do
        expect(builder.call).to be(true)
      end
    end

    it "builds file when enabled with Git and Git Lint only" do
      settings.merge! settings.minimize.merge(
        build_rake: true,
        build_git: true,
        build_git_lint: true
      )

      builder.call

      expect(path.read).to eq(<<~CONTENT)
        require "bundler/setup"
        require "git/lint/rake/register"

        Git::Lint::Rake::Register.call

        desc "Run code quality checks"
        task quality: %i[git_lint]

        task default: %i[quality]
      CONTENT
    end

    it "builds file when enabled with Reek only" do
      settings.merge! settings.minimize.merge(build_rake: true, build_reek: true)
      builder.call

      expect(path.read).to eq(<<~CONTENT)
        require "bundler/setup"
        require "reek/rake/task"

        Reek::Rake::Task.new

        desc "Run code quality checks"
        task quality: %i[reek]

        task default: %i[quality]
      CONTENT
    end

    it "builds file when enabled with RSpec only" do
      settings.merge! settings.minimize.merge(build_rake: true, build_rspec: true)
      builder.call

      expect(path.read).to eq(<<~CONTENT)
        require "bundler/setup"
        require "rspec/core/rake_task"

        RSpec::Core::RakeTask.new { |task| task.verbose = false }

        desc "Run code quality checks"
        task quality: %i[]

        task default: %i[quality spec]
      CONTENT
    end

    it "builds file when enabled with Caliber only" do
      settings.merge! settings.minimize.merge(build_rake: true, build_caliber: true)
      builder.call

      expect(path.read).to eq(<<~CONTENT)
        require "bundler/setup"
        require "rubocop/rake_task"

        RuboCop::RakeTask.new

        desc "Run code quality checks"
        task quality: %i[rubocop]

        task default: %i[quality]
      CONTENT
    end

    context "when enabled with all options" do
      before do
        settings.merge! settings.maximize
        builder.call
      end

      let :proof do
        <<~CONTENT
          require "bundler/setup"
          require "git/lint/rake/register"
          require "reek/rake/task"
          require "rspec/core/rake_task"
          require "rubocop/rake_task"

          Git::Lint::Rake::Register.call
          Reek::Rake::Task.new
          RSpec::Core::RakeTask.new { |task| task.verbose = false }
          RuboCop::RakeTask.new

          desc "Run code quality checks"
          task quality: %i[git_lint reek rubocop]

          task default: %i[quality spec]
        CONTENT
      end

      it "builds file" do
        expect(path.read).to eq(proof)
      end
    end

    context "when disabled" do
      before { settings.merge! settings.minimize }

      it "doesn't build file" do
        builder.call
        expect(path.exist?).to be(false)
      end

      it "answers false" do
        expect(builder.call).to be(false)
      end
    end
  end
end
