# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Bundler do
  using Refinements::Struct

  subject(:builder) { described_class.new }

  include_context "with application dependencies"

  describe "#call" do
    let(:gemfile_path) { temp_dir.join "test", "Gemfile" }

    it "builds Gemfile with minimum options" do
      settings.merge! settings.minimize
      builder.call

      expect(gemfile_path.read).to eq(<<~CONTENT)
        ruby file: ".ruby-version"

        source "https://rubygems.org"

      CONTENT
    end

    it "builds Gemfile with Amazing Print only" do
      settings.merge! settings.minimize.merge(build_amazing_print: true)
      builder.call

      expect(gemfile_path.read).to eq(<<~CONTENT)
        ruby file: ".ruby-version"

        source "https://rubygems.org"

        group :tools do
          gem "amazing_print", "~> 1.6"
        end
      CONTENT
    end

    it "builds Gemfile with Caliber only" do
      settings.merge! settings.minimize.merge(build_caliber: true)
      builder.call

      expect(gemfile_path.read).to eq(<<~CONTENT)
        ruby file: ".ruby-version"

        source "https://rubygems.org"

        group :quality do
          gem "caliber", "~> 0.58"
        end
      CONTENT
    end

    it "builds Gemfile with Debug only" do
      settings.merge! settings.minimize.merge(build_debug: true)
      builder.call

      expect(gemfile_path.read).to eq(<<~CONTENT)
        ruby file: ".ruby-version"

        source "https://rubygems.org"

        group :tools do
          gem "debug", "~> 1.9"
        end
      CONTENT
    end

    it "builds Gemfile with Git and Git Lint only" do
      settings.merge! settings.minimize.merge(build_git: true, build_git_lint: true)
      builder.call

      expect(gemfile_path.read).to eq(<<~CONTENT)
        ruby file: ".ruby-version"

        source "https://rubygems.org"

        group :quality do
          gem "git-lint", "~> 7.3"
        end
      CONTENT
    end

    it "builds Gemfile with Guard only" do
      settings.merge! settings.minimize.merge(build_guard: true)
      builder.call

      expect(gemfile_path.read).to eq(<<~CONTENT)
        ruby file: ".ruby-version"

        source "https://rubygems.org"

        group :test do
          gem "guard-rspec", "~> 4.7", require: false
        end
      CONTENT
    end

    it "builds Gemfile with IRB Kit only" do
      settings.merge! settings.minimize.merge(build_irb_kit: true)
      builder.call

      expect(gemfile_path.read).to eq(<<~CONTENT)
        ruby file: ".ruby-version"

        source "https://rubygems.org"

        group :tools do
          gem "irb-kit", "~> 0.0"
        end
      CONTENT
    end

    it "builds Gemfile with Rake only" do
      settings.merge! settings.minimize.merge(build_rake: true)
      builder.call

      expect(gemfile_path.read).to eq(<<~CONTENT)
        ruby file: ".ruby-version"

        source "https://rubygems.org"

        group :development do
          gem "rake", "~> 13.2"
        end
      CONTENT
    end

    it "builds Gemfile with Reek only" do
      settings.merge! settings.minimize.merge(build_reek: true)
      builder.call

      expect(gemfile_path.read).to eq(<<~CONTENT)
        ruby file: ".ruby-version"

        source "https://rubygems.org"

        group :quality do
          gem "reek", "~> 6.3", require: false
        end
      CONTENT
    end

    it "builds Gemfile with Refinements only" do
      settings.merge! settings.minimize.merge(build_refinements: true)
      builder.call

      expect(gemfile_path.read).to eq(<<~CONTENT)
        ruby file: ".ruby-version"

        source "https://rubygems.org"

        gem "refinements", "~> 12.5"
      CONTENT
    end

    it "builds Gemfile with RSpec only" do
      settings.merge! settings.minimize.merge(build_rspec: true)
      builder.call

      expect(gemfile_path.read).to eq(<<~CONTENT)
        ruby file: ".ruby-version"

        source "https://rubygems.org"

        group :test do
          gem "rspec", "~> 3.13"
        end
      CONTENT
    end

    it "builds Gemfile with Repl Type Completor only" do
      settings.merge! settings.minimize.merge(build_rtc: true)
      builder.call

      expect(gemfile_path.read).to eq(<<~CONTENT)
        ruby file: ".ruby-version"

        source "https://rubygems.org"

        group :tools do
          gem "repl_type_completor", "~> 0.1"
        end
      CONTENT
    end

    it "builds Gemfile with SimpleCov only" do
      settings.merge! settings.minimize.merge(build_simple_cov: true)
      builder.call

      expect(gemfile_path.read).to eq(<<~CONTENT)
        ruby file: ".ruby-version"

        source "https://rubygems.org"

        group :quality do
          gem "simplecov", "~> 0.22", require: false
        end
      CONTENT
    end

    it "builds Gemfile with Zeitwerk only" do
      settings.merge! settings.minimize.merge(build_zeitwerk: true)
      builder.call

      expect(gemfile_path.read).to eq(<<~CONTENT)
        ruby file: ".ruby-version"

        source "https://rubygems.org"

        gem "zeitwerk", "~> 2.6"
      CONTENT
    end

    it "builds Gemfile with Markdown only" do
      settings.merge! settings.minimize.merge(documentation_format: "md")
      builder.call

      expect(gemfile_path.read).to eq(<<~CONTENT)
        ruby file: ".ruby-version"

        source "https://rubygems.org"

        group :development do
          gem "tocer", "~> 18.0"
        end
      CONTENT
    end

    context "with all options using ASCII Doc" do
      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          gem "refinements", "~> 12.5"
          gem "zeitwerk", "~> 2.6"

          group :quality do
            gem "caliber", "~> 0.58"
            gem "git-lint", "~> 7.3"
            gem "reek", "~> 6.3", require: false
            gem "simplecov", "~> 0.22", require: false
          end

          group :development do
            gem "rake", "~> 13.2"
          end

          group :test do
            gem "guard-rspec", "~> 4.7", require: false
            gem "rspec", "~> 3.13"
          end

          group :tools do
            gem "amazing_print", "~> 1.6"
            gem "debug", "~> 1.9"
            gem "irb-kit", "~> 0.0"
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds Gemfile" do
        settings.merge! settings.maximize.merge(documentation_format: "adoc")
        builder.call

        expect(gemfile_path.read).to eq(proof)
      end
    end

    context "with all options using Markdown" do
      let :proof do
        <<~CONTENT
          ruby file: ".ruby-version"

          source "https://rubygems.org"

          gem "refinements", "~> 12.5"
          gem "zeitwerk", "~> 2.6"

          group :quality do
            gem "caliber", "~> 0.58"
            gem "git-lint", "~> 7.3"
            gem "reek", "~> 6.3", require: false
            gem "simplecov", "~> 0.22", require: false
          end

          group :development do
            gem "rake", "~> 13.2"
            gem "tocer", "~> 18.0"
          end

          group :test do
            gem "guard-rspec", "~> 4.7", require: false
            gem "rspec", "~> 3.13"
          end

          group :tools do
            gem "amazing_print", "~> 1.6"
            gem "debug", "~> 1.9"
            gem "irb-kit", "~> 0.0"
            gem "repl_type_completor", "~> 0.1"
          end
        CONTENT
      end

      it "builds Gemfile" do
        settings.merge! settings.maximize.merge(documentation_format: "md")
        builder.call

        expect(gemfile_path.read).to eq(proof)
      end
    end

    it "answers true" do
      expect(builder.call).to be(true)
    end
  end
end
