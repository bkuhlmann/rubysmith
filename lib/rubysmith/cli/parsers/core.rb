# frozen_string_literal: true

require "refinements/structs"

module Rubysmith
  module CLI
    module Parsers
      # Handles parsing of Command Line Interface (CLI) core options.
      class Core
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
          client.banner = specification.labeled_summary
          client.separator "\nUSAGE:\n"
          collate
          client.parse arguments
          configuration
        end

        private

        attr_reader :configuration, :client, :container

        def collate = private_methods.sort.grep(/add_/).each { |method| __send__ method }

        def add_config
          client.on "-c",
                    "--config ACTION",
                    %i[edit view],
                    "Manage gem configuration: edit or view." do |action|
            configuration.merge! action_config: action
          end
        end

        def add_build
          client.on "-b", "--build NAME [options]", "Build new project." do |name|
            configuration.merge! action_build: true, project_name: name
          end
        end

        def add_publish
          client.on "-p", "--publish VERSION", "Publish project." do |version|
            configuration.merge! action_publish: true, project_version: version
          end
        end

        def add_version
          client.on "-v", "--version", "Show gem version." do
            configuration.merge! action_version: true
          end
        end

        def add_help
          client.on "-h", "--help", "Show this message." do
            configuration.merge! action_help: true
          end
        end

        def specification = container[__method__]
      end
    end
  end
end
