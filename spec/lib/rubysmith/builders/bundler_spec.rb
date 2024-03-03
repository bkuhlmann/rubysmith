# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Bundler do
  using Refinements::Struct

  subject(:builder) { described_class.new test_configuration }

  include_context "with application dependencies"

  let(:gemfile_path) { temp_dir.join "test", "Gemfile" }

  it_behaves_like "a builder"

  describe "#call" do
    context "with minimum options" do
      let(:test_configuration) { configuration.minimize }

      it "builds Gemfile" do
        builder.call

        expect(gemfile_path.read).to eq(<<~CONTENT)
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          group :tools do
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end
    end

    context "with Amazing Print only" do
      let(:test_configuration) { configuration.minimize.merge build_amazing_print: true }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          group :tools do
            gem "amazing_print", "~> 1.5"
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end
    end

    context "with Caliber only" do
      let(:test_configuration) { configuration.minimize.merge build_caliber: true }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          group :quality do
            gem "caliber", "~> 0.51"
          end

          group :tools do
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end
    end

    context "with Debug only" do
      let(:test_configuration) { configuration.minimize.merge build_debug: true }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          group :tools do
            gem "debug", "~> 1.9"
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end
    end

    context "with Git and Git Lint only" do
      let :test_configuration do
        configuration.minimize.merge build_git: true, build_git_lint: true
      end

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          group :quality do
            gem "git-lint", "~> 7.1"
          end

          group :tools do
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end
    end

    context "with Guard only" do
      let(:test_configuration) { configuration.minimize.merge build_guard: true }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          group :test do
            gem "guard-rspec", "~> 4.7", require: false
          end

          group :tools do
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end
    end

    context "with Rake only" do
      let(:test_configuration) { configuration.minimize.merge build_rake: true }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          group :development do
            gem "rake", "~> 13.1"
          end

          group :tools do
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end
    end

    context "with Reek only" do
      let(:test_configuration) { configuration.minimize.merge build_reek: true }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          group :quality do
            gem "reek", "~> 6.3", require: false
          end

          group :tools do
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end
    end

    context "with Refinements only" do
      let(:test_configuration) { configuration.minimize.merge build_refinements: true }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          gem "refinements", "~> 12.0"

          group :tools do
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end
    end

    context "with RSpec only" do
      let(:test_configuration) { configuration.minimize.merge build_rspec: true }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          group :test do
            gem "rspec", "~> 3.12"
          end

          group :tools do
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end
    end

    context "with SimpleCov only" do
      let(:test_configuration) { configuration.minimize.merge build_simple_cov: true }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          group :quality do
            gem "simplecov", "~> 0.22", require: false
          end

          group :tools do
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end
    end

    context "with Zeitwerk only" do
      let(:test_configuration) { configuration.minimize.merge build_zeitwerk: true }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          gem "zeitwerk", "~> 2.6"

          group :tools do
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end
    end

    context "with Markdown only" do
      let(:test_configuration) { configuration.minimize.merge documentation_format: "md" }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          group :development do
            gem "tocer", "~> 17.0"
          end

          group :tools do
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end
    end

    context "with all options using ASCII Doc" do
      let(:test_configuration) { configuration.maximize.merge documentation_format: "adoc" }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          gem "refinements", "~> 12.0"
          gem "zeitwerk", "~> 2.6"

          group :quality do
            gem "caliber", "~> 0.51"
            gem "git-lint", "~> 7.1"
            gem "reek", "~> 6.3", require: false
            gem "simplecov", "~> 0.22", require: false
          end

          group :development do
            gem "rake", "~> 13.1"
          end

          group :test do
            gem "guard-rspec", "~> 4.7", require: false
            gem "rspec", "~> 3.12"
          end

          group :tools do
            gem "amazing_print", "~> 1.5"
            gem "debug", "~> 1.9"
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end
    end

    context "with all options using Markdown" do
      let(:test_configuration) { configuration.maximize.merge documentation_format: "md" }

      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          gem "refinements", "~> 12.0"
          gem "zeitwerk", "~> 2.6"

          group :quality do
            gem "caliber", "~> 0.51"
            gem "git-lint", "~> 7.1"
            gem "reek", "~> 6.3", require: false
            gem "simplecov", "~> 0.22", require: false
          end

          group :development do
            gem "rake", "~> 13.1"
            gem "tocer", "~> 17.0"
          end

          group :test do
            gem "guard-rspec", "~> 4.7", require: false
            gem "rspec", "~> 3.12"
          end

          group :tools do
            gem "amazing_print", "~> 1.5"
            gem "debug", "~> 1.9"
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end
    end
  end
end
