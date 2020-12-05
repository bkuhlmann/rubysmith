# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Bundler, :realm do
  subject(:builder) { described_class.new realm, runner: runner }

  let(:runner) { class_spy Bundler::CLI }
  let(:gemfile_path) { temp_dir.join "test", "Gemfile" }

  it_behaves_like "a builder"

  describe "#call" do
    shared_examples_for "a bundle" do
      it "installs gems" do
        builder.call
        expect(runner).to have_received(:start).with(%w[install --quiet])
      end
    end

    context "with default options" do
      let(:realm) { default_realm }

      it "builds Gemfile" do
        builder.call

        expect(gemfile_path.read).to eq(
          <<~CONTENT
            source "https://rubygems.org"

            group :development do
              gem "rake", "~> 13.0"
            end
          CONTENT
        )
      end

      it_behaves_like "a bundle"
    end

    context "with minimum options" do
      let(:realm) { default_realm.with build_minimum: true }

      it "builds Gemfile" do
        builder.call

        expect(gemfile_path.read).to eq(
          <<~CONTENT
            source "https://rubygems.org"
          CONTENT
        )
      end

      it_behaves_like "a bundle"
    end

    context "with only Bundler Audit" do
      let(:realm) { default_realm.with build_bundler_audit: true }

      let :proof do
        <<~CONTENT
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
      let(:realm) { default_realm.with build_bundler_leak: true }

      let :proof do
        <<~CONTENT
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
      let(:realm) { default_realm.with build_git: true, build_git_lint: true }

      let :proof do
        <<~CONTENT
          source "https://rubygems.org"

          group :code_quality do
            gem "git-lint", "~> 1.3"
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
      let(:realm) { default_realm.with build_guard: true }

      let :proof do
        <<~CONTENT
          source "https://rubygems.org"

          group :development do
            gem "rake", "~> 13.0"
          end

          group :test do
            gem "guard-rspec", "~> 4.7"
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
      let(:realm) { default_realm.with build_pry: true }

      let :content do
        <<~CONTENT
          source "https://rubygems.org"

          group :development do
            gem "pry", "~> 0.13"
            gem "pry-byebug", "~> 3.9"
            gem "rake", "~> 13.0"
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
      let(:realm) { default_realm.with build_reek: true }

      let :proof do
        <<~CONTENT
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

    context "with only RSpec" do
      let(:realm) { default_realm.with build_rspec: true }

      let :proof do
        <<~CONTENT
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

    context "with only Rubocop" do
      let(:realm) { default_realm.with build_rubocop: true }

      let :proof do
        <<~CONTENT
          source "https://rubygems.org"

          group :code_quality do
            gem "rubocop", "~> 1.3"
            gem "rubocop-performance", "~> 1.8"
            gem "rubocop-rake", "~> 0.5"
            gem "rubocop-rspec", "~> 2.0"
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
      let(:realm) { default_realm.with build_simple_cov: true }

      let :proof do
        <<~CONTENT
          source "https://rubygems.org"

          group :code_quality do
            gem "simplecov", "~> 0.19"
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
      let :realm do
        default_realm.with build_bundler_audit: true,
                           build_bundler_leak: true,
                           build_git: true,
                           build_git_lint: true,
                           build_guard: true,
                           build_pry: true,
                           build_reek: true,
                           build_rspec: true,
                           build_rubocop: true,
                           build_simple_cov: true
      end

      let :proof do
        <<~CONTENT
          source "https://rubygems.org"

          group :code_quality do
            gem "bundler-audit", "~> 0.7"
            gem "bundler-leak", "~> 0.2"
            gem "git-lint", "~> 1.3"
            gem "reek", "~> 6.0"
            gem "rubocop", "~> 1.3"
            gem "rubocop-performance", "~> 1.8"
            gem "rubocop-rake", "~> 0.5"
            gem "rubocop-rspec", "~> 2.0"
            gem "simplecov", "~> 0.19"
          end

          group :development do
            gem "pry", "~> 0.13"
            gem "pry-byebug", "~> 3.9"
            gem "rake", "~> 13.0"
          end

          group :test do
            gem "guard-rspec", "~> 4.7"
            gem "rspec", "~> 3.10"
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
