# frozen_string_literal: true

require "pragmater"

module Rubysmith
  module Builders
    # Builds project skeleton pragmas so all Ruby strings are frozen by default.
    class Pragma
      def self.call(...) = new(...).call

      def initialize configuration, client: Pragmater::Runner
        @configuration = configuration
        @client = client
      end

      def call = client.for(**attributes).call && configuration

      private

      attr_reader :configuration, :client

      def attributes
        {
          action: :insert,
          root_dir: configuration.project_root,
          comments: configuration.extensions_pragmater_comments,
          includes: configuration.extensions_pragmater_includes
        }
      end
    end
  end
end
