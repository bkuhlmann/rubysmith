# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Bundler do
  subject(:builder) { described_class.new configuration, client: client }

  include_context "with configuration"

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

    context "with default options" do
      let(:configuration) { default_configuration }

      it "builds Gemfile" do
        builder.call

        expect(gemfile_path.read).to eq(<<~CONTENT)
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :development do
            gem "rake", "~> 13.0"
          end
        CONTENT
      end

      it_behaves_like "a bundle"
    end

    context "with minimum options" do
      let(:configuration) { default_configuration.with build_minimum: true }

      it "builds Gemfile" do
        builder.call

        expect(gemfile_path.read).to eq(<<~CONTENT)
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

        CONTENT
      end

      it_behaves_like "a bundle"
    end

    context "with only Amazing Print" do
      let(:configuration) { default_configuration.with build_amazing_print: true }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :development do
            gem "rake", "~> 13.0"
          end

          group :tools do
            gem "amazing_print", "~> 1.2"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(proof)
      end

      it_behaves_like "a bundle"
    end

    context "with only Bundler Audit" do
      let(:configuration) { default_configuration.with build_bundler_audit: true }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "bundler-audit", "~> 0.7"
          end

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

    context "with only Bundler Leak" do
      let(:configuration) { default_configuration.with build_bundler_leak: true }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "bundler-leak", "~> 0.2"
          end

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

    context "with only Git and Git Lint" do
      let(:configuration) { default_configuration.with build_git: true, build_git_lint: true }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "git-lint", "~> 2.0"
          end

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

    context "with only Guard" do
      let(:configuration) { default_configuration.with build_guard: true }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :development do
            gem "rake", "~> 13.0"
          end

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

    context "with only Pry" do
      let(:configuration) { default_configuration.with build_pry: true }

      let :content do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :development do
            gem "rake", "~> 13.0"
          end

          group :tools do
            gem "pry", "~> 0.13"
            gem "pry-byebug", "~> 3.9"
          end
        CONTENT
      end

      it "builds Gemfile" do
        builder.call
        expect(gemfile_path.read).to eq(content)
      end

      it_behaves_like "a bundle"
    end

    context "with only Reek" do
      let(:configuration) { default_configuration.with build_reek: true }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "reek", "~> 6.0"
          end

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

    context "with only Refinements" do
      let(:configuration) { default_configuration.with build_refinements: true }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          gem "refinements", "~> 8.0"

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

    context "with only RSpec" do
      let(:configuration) { default_configuration.with build_rspec: true }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :development do
            gem "rake", "~> 13.0"
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

    context "with only RSpec and Rubocop" do
      let(:configuration) { default_configuration.with build_rspec: true, build_rubocop: true }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "rubocop", "~> 1.10"
            gem "rubocop-performance", "~> 1.9"
            gem "rubocop-rake", "~> 0.5"
            gem "rubocop-rspec", "~> 2.0"
          end

          group :development do
            gem "rake", "~> 13.0"
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

    context "with only Rubocop" do
      let(:configuration) { default_configuration.with build_rubocop: true }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "rubocop", "~> 1.10"
            gem "rubocop-performance", "~> 1.9"
            gem "rubocop-rake", "~> 0.5"
          end

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

    context "with only RubyCritic" do
      let(:configuration) { default_configuration.with build_ruby_critic: true }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "rubycritic", "~> 4.5", require: false
          end

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

    context "with only SimpleCov" do
      let(:configuration) { default_configuration.with build_simple_cov: true }

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          group :code_quality do
            gem "simplecov", "~> 0.20"
          end

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

    context "with all options" do
      let :configuration do
        default_configuration.with build_amazing_print: true,
                                   build_bundler_audit: true,
                                   build_bundler_leak: true,
                                   build_git: true,
                                   build_git_lint: true,
                                   build_guard: true,
                                   build_pry: true,
                                   build_reek: true,
                                   build_refinements: true,
                                   build_rspec: true,
                                   build_rubocop: true,
                                   build_ruby_critic: true,
                                   build_simple_cov: true
      end

      let :proof do
        <<~CONTENT
          ruby File.read(".ruby-version").strip

          source "https://rubygems.org"

          gem "refinements", "~> 8.0"

          group :code_quality do
            gem "bundler-audit", "~> 0.7"
            gem "bundler-leak", "~> 0.2"
            gem "git-lint", "~> 2.0"
            gem "reek", "~> 6.0"
            gem "rubocop", "~> 1.10"
            gem "rubocop-performance", "~> 1.9"
            gem "rubocop-rake", "~> 0.5"
            gem "rubocop-rspec", "~> 2.0"
            gem "rubycritic", "~> 4.5", require: false
            gem "simplecov", "~> 0.20"
          end

          group :development do
            gem "rake", "~> 13.0"
          end

          group :test do
            gem "guard-rspec", "~> 4.7", require: false
            gem "rspec", "~> 3.10"
          end

          group :tools do
            gem "amazing_print", "~> 1.2"
            gem "pry", "~> 0.13"
            gem "pry-byebug", "~> 3.9"
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
