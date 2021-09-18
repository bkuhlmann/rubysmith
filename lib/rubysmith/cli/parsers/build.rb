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
          client.on "--[no-]amazing_print", "Add Amazing Print." do |value|
            configuration.build_amazing_print = value
          end
        end

        def add_bundler_leak
          client.on "--[no-]bundler-leak", "Add Bundler Leak." do |value|
            configuration.build_bundler_leak = value
          end
        end

        def add_console
          client.on "--[no-]console", "Add console script." do |value|
            configuration.build_console = value
          end
        end

        def add_circle_ci
          client.on "--[no-]circle_ci", "Add Circle CI." do |value|
            configuration.build_circle_ci = value
          end
        end

        def add_debug
          client.on "--[no-]debug", "Add Debug." do |value|
            configuration.build_debug = value
          end
        end

        def add_documentation
          client.on "--[no-]documentation", "Add documentation." do |value|
            configuration.build_documentation = value
          end
        end

        def add_git
          client.on "--[no-]git", "Add Git." do |value|
            configuration.build_git = value
          end
        end

        def add_git_hub
          client.on "--[no-]git_hub", "Add GitHub." do |value|
            configuration.build_git_hub = value
          end
        end

        def add_git_lint
          client.on "--[no-]git-lint", "Add Git Lint." do |value|
            configuration.build_git_lint = value
          end
        end

        def add_guard
          client.on "--[no-]guard", "Add Guard." do |value|
            configuration.build_guard = value
          end
        end

        def add_minimum
          client.on "--min", "Use minimum/no options." do |value|
            configuration.minimize.build_minimum = value
          end
        end

        def add_rake
          client.on "--[no-]rake", "Add Rake." do |value|
            configuration.build_rake = value
          end
        end

        def add_reek
          client.on "--[no-]reek", "Add Reek." do |value|
            configuration.build_reek = value
          end
        end

        def add_refinements
          client.on "--[no-]refinements", "Add Refinements." do |value|
            configuration.build_refinements = value
          end
        end

        def add_rspec
          client.on "--[no-]rspec", "Add RSpec." do |value|
            configuration.build_rspec = value
          end
        end

        def add_rubocop
          client.on "--[no-]rubocop", "Add Rubocop." do |value|
            configuration.build_rubocop = value
          end
        end

        def add_setup
          client.on "--[no-]setup", "Add setup script." do |value|
            configuration.build_setup = value
          end
        end

        def add_simple_cov
          client.on "--[no-]simple_cov", "Add SimpleCov." do |value|
            configuration.build_simple_cov = value
          end
        end

        def add_zeitwerk
          client.on "--[no-]zeitwerk", "Add Zeitwerk." do |value|
            configuration.build_zeitwerk = value
          end
        end

        def configuration = container[__method__]
      end
    end
  end
end
