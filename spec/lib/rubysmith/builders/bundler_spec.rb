# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Bundler do
  subject(:builder) { described_class.new configuration, client: client }

  include_context "with application container"

  let(:client) { class_spy Bundler::CLI }
  let(:gemfile_path) { temp_dir.join "test", "Gemfile" }

  it_behaves_like "a builder"

  describe "#call" do
    shared_examples_for "a bundle" do
      it "installs gems" do
        builder.call
        expect(client).to have_received(:start).with(%w[install --quiet])
      end
    end

    context "with minimum options" do
      let(:configuration) { application_configuration.minimize.with documentation_format: nil }

      it "builds Gemfile" do
        builder.call

        expect(gemfile_path.read).to eq(<<~CONTENT)
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

        CONTENT
      end

      it_behaves_like "a bundle"
    end

    context "with Amazing Print only" do
      let :configuration do
        application_configuration.minimize.with build_amazing_print: true, documentation_format: nil
      end

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :tools do
            gem "amazing_print", "~> 1.3"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end

      it_behaves_like "a bundle"
    end

    context "with Bundler Leak only" do
      let :configuration do
        application_configuration.minimize.with build_bundler_leak: true, documentation_format: nil
      end

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "bundler-leak", "~> 0.2"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end

      it_behaves_like "a bundle"
    end

    context "with Debug only" do
      let :configuration do
        application_configuration.minimize.with build_debug: true, documentation_format: nil
      end

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :tools do
            gem "debug", "~> 1.1"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end

      it_behaves_like "a bundle"
    end

    context "with Git and Git Lint only" do
      let :configuration do
        application_configuration.minimize.with build_git: true,
                                                build_git_lint: true,
                                                documentation_format: nil
      end

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "git-lint", "~> 2.0"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end

      it_behaves_like "a bundle"
    end

    context "with Guard only" do
      let :configuration do
        application_configuration.minimize.with build_guard: true, documentation_format: nil
      end

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

      it_behaves_like "a bundle"
    end

    context "with Rake only" do
      let :configuration do
        application_configuration.minimize.with build_rake: true, documentation_format: nil
      end

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

      it_behaves_like "a bundle"
    end

    context "with Reek only" do
      let :configuration do
        application_configuration.minimize.with build_reek: true, documentation_format: nil
      end

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "reek", "~> 6.0"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end

      it_behaves_like "a bundle"
    end

    context "with Refinements only" do
      let :configuration do
        application_configuration.minimize.with build_refinements: true, documentation_format: nil
      end

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          gem "refinements", "~> 8.4"
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end

      it_behaves_like "a bundle"
    end

    context "with RSpec only" do
      let :configuration do
        application_configuration.minimize.with build_rspec: true, documentation_format: nil
      end

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :test do
            gem "rspec", "~> 3.10"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end

      it_behaves_like "a bundle"
    end

    context "with RSpec and Rubocop only" do
      let :configuration do
        application_configuration.minimize.with build_rspec: true,
                                                build_rubocop: true,
                                                documentation_format: nil
      end

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "rubocop", "~> 1.20"
            gem "rubocop-performance", "~> 1.11"
            gem "rubocop-rake", "~> 0.6"
            gem "rubocop-rspec", "~> 2.4"
          end

          group :test do
            gem "rspec", "~> 3.10"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end

      it_behaves_like "a bundle"
    end

    context "with Rubocop only" do
      let :configuration do
        application_configuration.minimize.with build_rubocop: true, documentation_format: nil
      end

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "rubocop", "~> 1.20"
            gem "rubocop-performance", "~> 1.11"
            gem "rubocop-rake", "~> 0.6"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end

      it_behaves_like "a bundle"
    end

    context "with SimpleCov only" do
      let :configuration do
        application_configuration.minimize.with build_simple_cov: true, documentation_format: nil
      end

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "simplecov", "~> 0.20"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end

      it_behaves_like "a bundle"
    end

    context "with Zeitwerk only" do
      let :configuration do
        application_configuration.minimize.with build_zeitwerk: true, documentation_format: nil
      end

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          gem "zeitwerk", "~> 2.4"
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end

      it_behaves_like "a bundle"
    end

    context "with Markdown only" do
      let(:configuration) { application_configuration.minimize.with documentation_format: "md" }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :development do
            gem "tocer", "~> 12.0"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end

      it_behaves_like "a bundle"
    end

    context "with all options" do
      let(:configuration) { application_configuration.maximize.with documentation_format: "md" }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          gem "refinements", "~> 8.4"
          gem "zeitwerk", "~> 2.4"

          group :code_quality do
            gem "bundler-leak", "~> 0.2"
            gem "git-lint", "~> 2.0"
            gem "reek", "~> 6.0"
            gem "rubocop", "~> 1.20"
            gem "rubocop-performance", "~> 1.11"
            gem "rubocop-rake", "~> 0.6"
            gem "rubocop-rspec", "~> 2.4"
            gem "simplecov", "~> 0.20"
          end

          group :development do
            gem "rake", "~> 13.0"
            gem "tocer", "~> 12.0"
          end

          group :test do
            gem "guard-rspec", "~> 4.7", require: false
            gem "rspec", "~> 3.10"
          end

          group :tools do
            gem "amazing_print", "~> 1.3"
            gem "debug", "~> 1.1"
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
