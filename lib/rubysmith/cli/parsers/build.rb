# frozen_string_literal: true

module Rubysmith
  module CLI
    module Parsers
      # Handles parsing of Command Line Interface (CLI) build options.
      class Build
        def self.call(...) = new(...).call

        def initialize options: {}, client: CLIENT
          @options = options
          @client = client
        end

        def call arguments = []
          client.separator "\nBUILD OPTIONS:\n"
          private_methods.sort.grep(/add_/).each { |method| __send__ method }
          arguments.empty? ? arguments : client.parse!(arguments)
        end

        private

        attr_reader :options, :client

        def add_minimum
          client.on "--min", "Use minimum/no options." do |value|
            options[:build_minimum] = value
          end
        end

        def add_amazing_print
          client.on "--[no-]amazing_print", "Add Amazing Print." do |value|
            options[:build_amazing_print] = value
          end
        end

        def add_bundler_leak
          client.on "--[no-]bundler-leak", "Add Bundler Leak." do |value|
            options[:build_bundler_leak] = value
          end
        end

        def add_console
          client.on "--[no-]console", "Add console script." do |value|
            options[:build_console] = value
          end
        end

        def add_documentation
          client.on "--[no-]documentation", "Add documentation." do |value|
            options[:build_documentation] = value
          end
        end

        def add_git
          client.on "--[no-]git", "Add Git." do |value|
            options[:build_git] = value
          end
        end

        def add_git_lint
          client.on "--[no-]git-lint", "Add Git Lint." do |value|
            options[:build_git_lint] = value
          end
        end

        def add_guard
          client.on "--[no-]guard", "Add Guard." do |value|
            options[:build_guard] = value
          end
        end

        def add_pry
          client.on "--[no-]pry", "Add Pry." do |value|
            options[:build_pry] = value
          end
        end

        def add_rake
          client.on "--[no-]rake", "Add Rake." do |value|
            options[:build_rake] = value
          end
        end

        def add_reek
          client.on "--[no-]reek", "Add Reek." do |value|
            options[:build_reek] = value
          end
        end

        def add_refinements
          client.on "--[no-]refinements", "Add Refinements." do |value|
            options[:build_refinements] = value
          end
        end

        def add_rspec
          client.on "--[no-]rspec", "Add RSpec." do |value|
            options[:build_rspec] = value
          end
        end

        def add_rubocop
          client.on "--[no-]rubocop", "Add Rubocop." do |value|
            options[:build_rubocop] = value
          end
        end

        def add_setup
          client.on "--[no-]setup", "Add setup script." do |value|
            options[:build_setup] = value
          end
        end

        def add_simple_cov
          client.on "--[no-]simple_cov", "Add SimpleCov." do |value|
            options[:build_simple_cov] = value
          end
        end

        def add_zeitwerk
          client.on "--[no-]zeitwerk", "Add Zeitwerk." do |value|
            options[:build_zeitwerk] = value
          end
        end
      end
    end
  end
end
