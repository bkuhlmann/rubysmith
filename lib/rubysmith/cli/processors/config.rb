# frozen_string_literal: true

module Rubysmith
  module CLI
    module Processors
      # Handles the Command Line Interface (CLI) configuration processing.
      class Config
        def initialize client: CLI::Configuration::Loader::CLIENT, container: Container
          @client = client
          @container = container
        end

        def call selection
          case selection
            when :edit then edit
            when :view then view
            else fail StandardError, "Invalid configuration selection: #{selection}."
          end
        end

        private

        attr_reader :client, :container

        def edit = kernel.system("$EDITOR #{client.current}")

        def view = kernel.system("cat #{client.current}")

        def kernel = container[__method__]
      end
    end
  end
end
