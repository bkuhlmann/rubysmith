# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Bundler do
  using Refinements::Structs

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
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

        CONTENT
      end
    end

    context "with Amazing Print only" do
      let(:test_configuration) { configuration.minimize.merge build_amazing_print: true }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :tools do
            gem "amazing_print", "~> 1.4"
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
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "caliber", "~> 0.30"
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
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :tools do
            gem "debug", "~> 1.8"
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
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "git-lint", "~> 5.0"
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
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :test do
            gem "guard-rspec", "~> 4.7", require: false
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
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :development do
            gem "rake", "~> 13.0"
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
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "reek", "~> 6.1", require: false
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
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          gem "refinements", "~> 10.0"
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
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :test do
            gem "rspec", "~> 3.12"
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
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "simplecov", "~> 0.22", require: false
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end
    end

    context "with YARD only" do
      let(:test_configuration) { configuration.minimize.merge build_yard: true }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :development do
            gem "asciidoctor", "~> 2.0"
            gem "yard", "~> 0.9"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end
    end

    context "with YARD only using Markdown" do
      let :test_configuration do
        configuration.minimize.merge build_yard: true, documentation_format: "md"
      end

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :development do
            gem "tocer", "~> 15.0"
            gem "yard", "~> 0.9"
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
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          gem "zeitwerk", "~> 2.6"
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
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :development do
            gem "tocer", "~> 15.0"
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
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          gem "refinements", "~> 10.0"
          gem "zeitwerk", "~> 2.6"

          group :code_quality do
            gem "caliber", "~> 0.30"
            gem "git-lint", "~> 5.0"
            gem "reek", "~> 6.1", require: false
            gem "simplecov", "~> 0.22", require: false
          end

          group :development do
            gem "asciidoctor", "~> 2.0"
            gem "rake", "~> 13.0"
            gem "yard", "~> 0.9"
          end

          group :test do
            gem "guard-rspec", "~> 4.7", require: false
            gem "rspec", "~> 3.12"
          end

          group :tools do
            gem "amazing_print", "~> 1.4"
            gem "debug", "~> 1.8"
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
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          gem "refinements", "~> 10.0"
          gem "zeitwerk", "~> 2.6"

          group :code_quality do
            gem "caliber", "~> 0.30"
            gem "git-lint", "~> 5.0"
            gem "reek", "~> 6.1", require: false
            gem "simplecov", "~> 0.22", require: false
          end

          group :development do
            gem "rake", "~> 13.0"
            gem "tocer", "~> 15.0"
            gem "yard", "~> 0.9"
          end

          group :test do
            gem "guard-rspec", "~> 4.7", require: false
            gem "rspec", "~> 3.12"
          end

          group :tools do
            gem "amazing_print", "~> 1.4"
            gem "debug", "~> 1.8"
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
