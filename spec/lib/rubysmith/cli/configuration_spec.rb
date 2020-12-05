# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubysmith::CLI::Configuration, :runcom do
  subject(:configuration) { described_class.new client: runcom_configuration }

  describe "#to_h" do
    let :proof do
      {
        project_name: nil,
        author_name: nil,
        author_email: nil,
        author_url: nil,
        documentation_format: "md",
        documentation_license: "mit",
        build_minimum: false,
        build_amazing_print: true,
        build_bundler_audit: true,
        build_bundler_leak: true,
        build_console: true,
        build_documentation: true,
        build_git: true,
        build_git_lint: true,
        build_guard: true,
        build_pry: true,
        build_reek: true,
        build_refinements: true,
        build_rspec: true,
        build_rubocop: true,
        build_setup: true,
        build_simple_cov: true,
        builders_pragmater_comments: ["# frozen_string_literal: true"],
        builders_pragmater_includes: [
          "**/*.rb",
          "**/*bin/console",
          "**/*bin/guard",
          "**/*bin/rubocop",
          "**/*Gemfile",
          "**/*Guardfile",
          "**/*Rakefile"
        ]
      }
    end

    it "answers default configuration" do
      expect(configuration.to_h).to eq(proof)
    end
  end
end
