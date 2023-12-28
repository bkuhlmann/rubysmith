# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Rake do
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

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
          task quality: %i[]

          task default: %i[quality]
        CONTENT
      end

      it "builds binstub" do
        expect(temp_dir.join("test/bin/rake").read).to eq(<<~CONTENT)
          #! /usr/bin/env ruby

          require "bundler/setup"

          load Gem.bin_path "rake", "rake"
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
          require "git/lint/rake/register"

          Git::Lint::Rake::Register.call

          desc "Run code quality checks"
          task quality: %i[git_lint]

          task default: %i[quality]
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
          task quality: %i[reek]

          task default: %i[quality]
        CONTENT
      end
    end

    context "when enabled with only RSpec" do
      let(:test_configuration) { configuration.minimize.merge build_rake: true, build_rspec: true }

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(<<~CONTENT)
          require "bundler/setup"
          require "rspec/core/rake_task"

          RSpec::Core::RakeTask.new { |task| task.verbose = false }

          desc "Run code quality checks"
          task quality: %i[]

          task default: %i[quality spec]
        CONTENT
      end
    end

    context "when enabled with only Caliber" do
      let :test_configuration do
        configuration.minimize.merge build_rake: true, build_caliber: true
      end

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(<<~CONTENT)
          require "bundler/setup"
          require "rubocop/rake_task"

          RuboCop::RakeTask.new

          desc "Run code quality checks"
          task quality: %i[rubocop]

          task default: %i[quality]
        CONTENT
      end
    end

    context "when enabled with only YARD" do
      let :test_configuration do
        configuration.minimize.merge build_rake: true, build_yard: true
      end

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(<<~CONTENT)
          require "bundler/setup"
          require "yard"

          YARD::Rake::YardocTask.new do |task|
            task.options = ["--title", "Test", "--output-dir", "doc/yard"]
          end

          desc "Run code quality checks"
          task quality: %i[]

          task default: %i[quality]
        CONTENT
      end
    end

    context "when enabled with all options" do
      let(:test_configuration) { configuration.maximize }

      let :proof do
        <<~CONTENT
          require "bundler/setup"
          require "git/lint/rake/register"
          require "reek/rake/task"
          require "rspec/core/rake_task"
          require "rubocop/rake_task"
          require "yard"

          Git::Lint::Rake::Register.call
          Reek::Rake::Task.new
          RSpec::Core::RakeTask.new { |task| task.verbose = false }
          RuboCop::RakeTask.new

          YARD::Rake::YardocTask.new do |task|
            task.options = ["--title", "Test", "--output-dir", "doc/yard"]
          end

          desc "Run code quality checks"
          task quality: %i[git_lint reek rubocop]

          task default: %i[quality spec]
        CONTENT
      end

      it "builds Rakefile" do
        expect(rakefile_path.read).to eq(proof)
      end
    end

    context "when disabled" do
      let(:test_configuration) { configuration.minimize }

      it "doesn't build binstub" do
        expect(temp_dir.join("test/bin/rake").exist?).to be(false)
      end

      it "doesn't build Rakefile" do
        expect(rakefile_path.exist?).to be(false)
      end
    end
  end
end
