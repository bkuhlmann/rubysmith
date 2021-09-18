# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::Builders::Documentation do
  using Refinements::Pathnames

  subject(:builder) { described_class.new configuration }

  include_context "with configuration"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    shared_examples_for "markdown documentation" do
      it "builds changes" do
        expect(temp_dir.join("test", "CHANGES.md").read).to eq(<<~CONTENT)
          # Changes

          ## 0.1.0 (2020-01-01)

          - Added initial implementation.
        CONTENT
      end

      it "builds code of conduct" do
        expect(temp_dir.join("test", "CODE_OF_CONDUCT.md").read).to include(
          "[Jill Smith](mailto:jill@example.com?subject=Conduct)"
        )
      end

      it "builds contributing guidelines" do
        expect(temp_dir.join("test", "CONTRIBUTING.md").read).to match(
          /Contributing.+Code.+Issues.+Feedback.+/m
        )
      end

      it "builds readme with minimum options" do
        expect(temp_dir.join("test", "README.md").read).to eq(
          Bundler.root.join("spec", "support", "boms", "readme-minimum.md").read
        )
      end

      context "with maximum options" do
        let :configuration do
          default_configuration.with build_documentation: true,
                                     build_circle_ci: true,
                                     build_console: true,
                                     build_rubocop: true,
                                     build_setup: true,
                                     documentation_format: "md"
        end

        it "builds readme" do
          expect(temp_dir.join("test", "README.md").read).to eq(
            Bundler.root.join("spec", "support", "boms", "readme-maximum.md").read
          )
        end
      end
    end

    shared_examples_for "a Markdown, MIT license" do
      it "builds license" do
        expect(temp_dir.join("test", "LICENSE.md").read).to include(
          "Copyright 2020 [Jill Smith](https://www.jillsmith.com)."
        )
      end
    end

    context "when enabled with Markdown format" do
      let :configuration do
        default_configuration.with build_documentation: true, documentation_format: "md"
      end

      it_behaves_like "markdown documentation"
    end

    context "when enabled with Markdown format and maximum options" do
      let :configuration do
        default_configuration.with build_documentation: true,
                                   build_setup: true,
                                   build_console: true,
                                   build_circle_ci: true,
                                   build_rubocop: true,
                                   documentation_format: "md"
      end

      it "builds readme" do
        expect(temp_dir.join("test", "README.md").read).to eq(
          Bundler.root.join("spec", "support", "boms", "readme-maximum.md").read
        )
      end
    end

    context "when enabled with Markdown format and MIT license" do
      let :configuration do
        default_configuration.with build_documentation: true,
                                   documentation_format: "md",
                                   documentation_license: "mit"
      end

      it_behaves_like "a Markdown, MIT license"
    end

    context "when enabled with ASCII Doc format" do
      let :configuration do
        default_configuration.with build_documentation: true, documentation_format: "adoc"
      end

      it "builds changes" do
        expect(temp_dir.join("test", "CHANGES.adoc").read).to eq(<<~CONTENT)
          = Changes

          == 0.1.0 (2020-01-01)

          * Added initial implementation.
        CONTENT
      end

      it "builds code of conduct" do
        expect(temp_dir.join("test", "CODE_OF_CONDUCT.adoc").read).to include(
          "link:mailto:jill@example.com?subject=Conduct[Jill Smith]"
        )
      end

      it "builds contributing guidelines" do
        expect(temp_dir.join("test", "CONTRIBUTING.adoc").read).to match(
          /Contributing.+Code.+Issues.+Feedback.+/m
        )
      end

      it "builds readme with minimum options" do
        expect(temp_dir.join("test", "README.adoc").read).to eq(
          Bundler.root.join("spec", "support", "boms", "readme-minimum.adoc").read
        )
      end
    end

    context "when enabled with ASCII Doc format and maximum options" do
      let :configuration do
        default_configuration.with build_documentation: true,
                                   build_circle_ci: true,
                                   build_console: true,
                                   build_rubocop: true,
                                   build_setup: true,
                                   documentation_format: "adoc"
      end

      it "builds readme" do
        expect(temp_dir.join("test", "README.adoc").read).to eq(
          Bundler.root.join("spec", "support", "boms", "readme-maximum.adoc").read
        )
      end
    end

    context "when enabled with ASCII Doc format and Apache license" do
      let :configuration do
        default_configuration.with build_documentation: true,
                                   documentation_format: "adoc",
                                   documentation_license: "apache"
      end

      it "builds license" do
        expect(temp_dir.join("test", "LICENSE.adoc").read).to include(
          "Copyright 2020 link:https://www.jillsmith.com[Jill Smith]."
        )
      end
    end

    context "when enabled without format or license defined" do
      let(:configuration) { default_configuration.with build_documentation: true }

      it_behaves_like "markdown documentation"
      it_behaves_like "a Markdown, MIT license"
    end

    context "when disabled" do
      let(:configuration) { default_configuration.with build_documentation: false }

      it "doesn't build documentation" do
        expect(temp_dir.files.empty?).to eq(true)
      end
    end
  end
end
