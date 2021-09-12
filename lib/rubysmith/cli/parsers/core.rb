# frozen_string_literal: true

require "rubysmith/identity"
require "refinements/structs"

module Rubysmith
  module CLI
    module Parsers
      # Handles parsing of Command Line Interface (CLI) core options.
      class Core
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize client: CLIENT, container: Container
          @client = client
          @container = container
        end

        def call arguments = []
          client.banner = "#{Identity::LABEL} - #{Identity::SUMMARY}"
          client.separator "\nUSAGE:\n"
          collate
          arguments.empty? ? arguments : client.parse!(arguments)
        end

        private

        attr_reader :client, :container

        def collate = private_methods.sort.grep(/add_/).each { |method| __send__ method }

        def add_config
          client.on "-c",
                    "--config ACTION",
                    %i[edit view],
                    "Manage gem configuration: edit or view." do |action|
            configuration.config = action
          end
        end

        def add_build
          client.on "-b", "--build NAME [options]", "Build new project." do |name|
            configuration.merge! build_any: true, project_name: name
          end
        end

        def add_version
          client.on "-v", "--version", "Show gem version." do
            configuration.version = Identity::VERSION_LABEL
          end
        end

        def add_help
          client.on "-h", "--help", "Show this message." do
            configuration.help = true
          end
        end

        def configuration = container[__method__]
      end
    end
  end
end
