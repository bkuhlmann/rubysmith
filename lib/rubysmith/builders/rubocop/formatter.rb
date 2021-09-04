# frozen_string_literal: true

require "rubocop"
require "refinements/ios"

module Rubysmith
  module Builders
    module Rubocop
      # Executes Rubocop auto-correct on newly generated project.
      class Formatter
        using Refinements::IOs

        def self.call(...) = new(...).call

        def initialize configuration, client: RuboCop::CLI.new
          @configuration = configuration
          @client = client
        end

        def call
          STDOUT.squelch { client.run ["--auto-correct", configuration.project_root.to_s] }
          nil
        end

        private

        attr_reader :configuration, :client
      end
    end
  end
end
