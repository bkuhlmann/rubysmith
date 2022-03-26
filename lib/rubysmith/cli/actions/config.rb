# frozen_string_literal: true

module Rubysmith
  module CLI
    module Actions
      # Handles the config action.
      class Config
        include Rubysmith::Import[:kernel, :logger]

        def initialize client: Configuration::Loader::CLIENT, **dependencies
          super(**dependencies)
          @client = client
        end

        def call selection
          case selection
            when :edit then edit
            when :view then view
            else logger.error { "Invalid configuration selection: #{selection}." }
          end
        end

        private

        attr_reader :client

        def edit = kernel.system("$EDITOR #{client.current}")

        def view = kernel.system("cat #{client.current}")
      end
    end
  end
end
