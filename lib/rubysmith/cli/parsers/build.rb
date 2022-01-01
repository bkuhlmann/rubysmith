# frozen_string_literal: true

require "refinements/structs"

module Rubysmith
  module CLI
    module Parsers
      # Handles parsing of Command Line Interface (CLI) build options.
      class Build
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration = Container[:configuration],
                       client: Parser::CLIENT,
                       container: Container
          @configuration = configuration
          @client = client
          @container = container
        end

        def call arguments = []
          client.separator "\nBUILD OPTIONS:\n"
          collate
          client.parse arguments
          configuration
        end

        private

        attr_reader :configuration, :client, :container

        def collate = private_methods.sort.grep(/add_/).each { |method| __send__ method }

        def add_amazing_print
          client.on(
            "--[no-]amazing_print",
            "Add Amazing Print gem. #{default __method__}."
          ) do |value|
            configuration.merge! build_amazing_print: value
          end
        end

        def add_bundler_leak
          client.on(
            "--[no-]bundler-leak",
            "Add Bundler Leak gem. #{default __method__}."
          ) do |value|
            configuration.merge! build_bundler_leak: value
          end
        end

        def add_console
          client.on(
            "--[no-]console",
            "Add console script. #{default __method__}."
          ) do |value|
            configuration.merge! build_console: value
          end
        end

        def add_contributions
          client.on(
            "--[no-]contributions",
            "Add contributions documentation. #{default __method__}."
          ) do |value|
            configuration.merge! build_contributions: value
          end
        end

        def add_circle_ci
          client.on(
            "--[no-]circle_ci",
            "Add Circle CI configuration and badge. #{default __method__}."
          ) do |value|
            configuration.merge! build_circle_ci: value
          end
        end

        def add_citation
          client.on(
            "--[no-]citation",
            "Add citation documentation. #{default __method__}."
          ) do |value|
            configuration.merge! build_citation: value
          end
        end

        def add_community
          client.on(
            "--[no-]community",
            "Add community documentation. #{default __method__}."
          ) do |value|
            configuration.merge! build_community: value
          end
        end

        def add_conduct
          client.on(
            "--[no-]conduct",
            "Add code of conduct documentation. #{default __method__}."
          ) do |value|
            configuration.merge! build_conduct: value
          end
        end

        def add_dead_end
          client.on(
            "--[no-]dead_end",
            "Add Dead End gem. #{default __method__}."
          ) do |value|
            configuration.merge! build_dead_end: value
          end
        end

        def add_debug
          client.on(
            "--[no-]debug",
            "Add Debug gem. #{default __method__}."
          ) do |value|
            configuration.merge! build_debug: value
          end
        end

        def add_git
          client.on(
            "--[no-]git",
            "Add Git. #{default __method__}."
          ) do |value|
            configuration.merge! build_git: value
          end
        end

        def add_git_hub
          client.on(
            "--[no-]git_hub",
            "Add GitHub templates. #{default __method__}."
          ) do |value|
            configuration.merge! build_git_hub: value
          end
        end

        def add_git_lint
          client.on(
            "--[no-]git-lint",
            "Add Git Lint gem. #{default __method__}."
          ) do |value|
            configuration.merge! build_git_lint: value
          end
        end

        def add_guard
          client.on(
            "--[no-]guard",
            "Add Guard gem. #{default __method__}."
          ) do |value|
            configuration.merge! build_guard: value
          end
        end

        def add_license
          client.on(
            "--[no-]license",
            "Add license documentation. #{default __method__}."
          ) do |value|
            configuration.merge! build_license: value
          end
        end

        def add_maximum
          client.on(
            "--max",
            "Use maximum/enabled options. #{default __method__}."
          ) do
            configuration.merge!(**configuration.maximize.to_h)
          end
        end

        def add_minimum
          client.on(
            "--min",
            "Use minimum/disabled options. #{default __method__}."
          ) do
            configuration.merge!(**configuration.minimize.to_h)
          end
        end

        def add_rake
          client.on(
            "--[no-]rake",
            "Add Rake gem. #{default __method__}."
          ) do |value|
            configuration.merge! build_rake: value
          end
        end

        def add_readme
          client.on(
            "--[no-]readme",
            "Add readme documentation. #{default __method__}."
          ) do |value|
            configuration.merge! build_readme: value
          end
        end

        def add_reek
          client.on(
            "--[no-]reek",
            "Add Reek gem. #{default __method__}."
          ) do |value|
            configuration.merge! build_reek: value
          end
        end

        def add_refinements
          client.on(
            "--[no-]refinements",
            "Add Refinements gem. #{default __method__}."
          ) do |value|
            configuration.merge! build_refinements: value
          end
        end

        def add_rspec
          client.on(
            "--[no-]rspec",
            "Add RSpec gem. #{default __method__}."
          ) do |value|
            configuration.merge! build_rspec: value
          end
        end

        def add_rubocop
          client.on(
            "--[no-]rubocop",
            "Add RuboCop gems. #{default __method__}."
          ) do |value|
            configuration.merge! build_rubocop: value
          end
        end

        def add_setup
          client.on(
            "--[no-]setup",
            "Add setup script. #{default __method__}."
          ) do |value|
            configuration.merge! build_setup: value
          end
        end

        def add_simple_cov
          client.on(
            "--[no-]simple_cov",
            "Add SimpleCov gem. #{default __method__}."
          ) do |value|
            configuration.merge! build_simple_cov: value
          end
        end

        def add_versions
          client.on(
            "--[no-]versions",
            "Add version history. #{default __method__}."
          ) do |value|
            configuration.merge! build_versions: value
          end
        end

        def add_zeitwerk
          client.on(
            "--[no-]zeitwerk",
            "Add Zeitwerk gem. #{default __method__}."
          ) do |value|
            configuration.merge! build_zeitwerk: value
          end
        end

        def default option
          option.to_s
                .sub("add_", "build_")
                .then { |attribute| configuration.public_send attribute }
                .then { |boolean| boolean ? colorizer.green(boolean) : colorizer.red(boolean) }
                .then { |colored_boolean| "Default: #{colored_boolean}" }
        end

        def colorizer = container[__method__]
      end
    end
  end
end
