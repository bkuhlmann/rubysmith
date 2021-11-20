# frozen_string_literal: true

module Rubysmith
  module CLI
    module Parsers
      # Handles parsing of Command Line Interface (CLI) build options.
      class Build
        def self.call(...) = new(...).call

        def initialize client: CLIENT, container: Container
          @client = client
          @container = container
        end

        def call arguments = []
          client.separator "\nBUILD OPTIONS:\n"
          private_methods.sort.grep(/add_/).each { |method| __send__ method }
          arguments.empty? ? arguments : client.parse!(arguments)
        end

        private

        attr_reader :client, :container

        def add_amazing_print
          client.on(
            "--[no-]amazing_print",
            "Add Amazing Print gem. #{default __method__}."
          ) do |value|
            configuration.build_amazing_print = value
          end
        end

        def add_bundler_leak
          client.on(
            "--[no-]bundler-leak",
            "Add Bundler Leak gem. #{default __method__}."
          ) do |value|
            configuration.build_bundler_leak = value
          end
        end

        def add_changes
          client.on(
            "--[no-]changes",
            "Add CHANGES documentation. #{default __method__}."
          ) do |value|
            configuration.build_changes = value
          end
        end

        def add_console
          client.on(
            "--[no-]console",
            "Add console script. #{default __method__}."
          ) do |value|
            configuration.build_console = value
          end
        end

        def add_contributions
          client.on(
            "--[no-]contributions",
            "Add CONTRIBUTING documentation. #{default __method__}."
          ) do |value|
            configuration.build_contributions = value
          end
        end

        def add_circle_ci
          client.on(
            "--[no-]circle_ci",
            "Add Circle CI configuration and badge. #{default __method__}."
          ) do |value|
            configuration.build_circle_ci = value
          end
        end

        def add_community
          client.on(
            "--[no-]community",
            "Add community documentation. #{default __method__}."
          ) do |value|
            configuration.build_community = value
          end
        end

        def add_conduct
          client.on(
            "--[no-]conduct",
            "Add CODE_OF_CONDUCT documentation. #{default __method__}."
          ) do |value|
            configuration.build_conduct = value
          end
        end

        def add_debug
          client.on(
            "--[no-]debug",
            "Add Debug gem. #{default __method__}."
          ) do |value|
            configuration.build_debug = value
          end
        end

        def add_git
          client.on(
            "--[no-]git",
            "Add Git. #{default __method__}."
          ) do |value|
            configuration.build_git = value
          end
        end

        def add_git_hub
          client.on(
            "--[no-]git_hub",
            "Add GitHub templates. #{default __method__}."
          ) do |value|
            configuration.build_git_hub = value
          end
        end

        def add_git_lint
          client.on(
            "--[no-]git-lint",
            "Add Git Lint gem. #{default __method__}."
          ) do |value|
            configuration.build_git_lint = value
          end
        end

        def add_guard
          client.on(
            "--[no-]guard",
            "Add Guard gem. #{default __method__}."
          ) do |value|
            configuration.build_guard = value
          end
        end

        def add_license
          client.on(
            "--[no-]license",
            "Add LICENSE documentation. #{default __method__}."
          ) do |value|
            configuration.build_license = value
          end
        end

        def add_maximum
          client.on(
            "--max",
            "Use maximum/enabled options. #{default __method__}."
          ) do |value|
            configuration.maximize.build_maximum = value
          end
        end

        def add_minimum
          client.on(
            "--min",
            "Use minimum/disabled options. #{default __method__}."
          ) do |value|
            configuration.minimize.build_minimum = value
          end
        end

        def add_rake
          client.on(
            "--[no-]rake",
            "Add Rake gem. #{default __method__}."
          ) do |value|
            configuration.build_rake = value
          end
        end

        def add_readme
          client.on(
            "--[no-]readme",
            "Add README documentation. #{default __method__}."
          ) do |value|
            configuration.build_readme = value
          end
        end

        def add_reek
          client.on(
            "--[no-]reek",
            "Add Reek gem. #{default __method__}."
          ) do |value|
            configuration.build_reek = value
          end
        end

        def add_refinements
          client.on(
            "--[no-]refinements",
            "Add Refinements gem. #{default __method__}."
          ) do |value|
            configuration.build_refinements = value
          end
        end

        def add_rspec
          client.on(
            "--[no-]rspec",
            "Add RSpec gem. #{default __method__}."
          ) do |value|
            configuration.build_rspec = value
          end
        end

        def add_rubocop
          client.on(
            "--[no-]rubocop",
            "Add Rubocop gems. #{default __method__}."
          ) do |value|
            configuration.build_rubocop = value
          end
        end

        def add_setup
          client.on(
            "--[no-]setup",
            "Add setup script. #{default __method__}."
          ) do |value|
            configuration.build_setup = value
          end
        end

        def add_simple_cov
          client.on(
            "--[no-]simple_cov",
            "Add SimpleCov gem. #{default __method__}."
          ) do |value|
            configuration.build_simple_cov = value
          end
        end

        def add_zeitwerk
          client.on(
            "--[no-]zeitwerk",
            "Add Zeitwerk gem. #{default __method__}."
          ) do |value|
            configuration.build_zeitwerk = value
          end
        end

        def default option
          option.to_s
                .sub("add_", "build_")
                .then { |attribute| configuration.public_send attribute }
                .then { |boolean| boolean ? colorizer.green(boolean) : colorizer.red(boolean) }
                .then { |colored_boolean| "Default: #{colored_boolean}" }
        end

        def configuration = container[__method__]

        def colorizer = container[__method__]
      end
    end
  end
end
