# frozen_string_literal: true

require "refinements/ios"
require "rubocop"

module Rubysmith
  module Extensions
    # Ensures project skeleton adheres to style guide.
    class Rubocop
      using Refinements::IOs

      def self.call(...) = new(...).call

      def initialize configuration, client: ::RuboCop::CLI.new
        @configuration = configuration
        @client = client
      end

      def call
        STDOUT.squelch { client.run ["--autocorrect", configuration.project_root.to_s] }
        configuration
      end

      private

      attr_reader :configuration, :client
    end
  end
end
