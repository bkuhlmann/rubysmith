# frozen_string_literal: true

module Rubysmith
  module CLI
    module Parsers
      # Handles parsing of Command Line Interface (CLI) build options.
      class Build
        def self.call client:, options:
          new(client: client, options: options).call
        end

        def initialize client: CLIENT, options: {}
          @client = client
          @options = options
        end

        def call arguments = []
          client.separator "\nBUILD OPTIONS:\n"
          private_methods.grep(/add_/).each(&method(:__send__))
          arguments.empty? ? arguments : client.parse!(arguments)
        end

        private

        attr_reader :client, :options

        def add_bundler_audit
          client.on "--[no-]bundler-audit", "Add Bundler Audit." do |value|
            options[:build_bundler_audit] = value
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

        def add_reek
          client.on "--[no-]reek", "Add Reek." do |value|
            options[:build_reek] = value
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
      end
    end
  end
end
