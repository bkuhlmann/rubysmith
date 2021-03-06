# frozen_string_literal: true

require "pragmater"

module Rubysmith
  module Builders
    # Builds project skeleton pragmas so all Ruby strings are frozen by default.
    class Pragma
      def self.call(configuration) = new(configuration).call

      def initialize configuration, client: Pragmater::Runner
        @configuration = configuration
        @client = client
      end

      def call = client.for(**attributes).call && nil

      private

      attr_reader :configuration, :client

      def attributes
        {
          action: :insert,
          root_dir: configuration.project_root,
          comments: configuration.builders_pragmater_comments,
          includes: configuration.builders_pragmater_includes
        }
      end
    end
  end
end
