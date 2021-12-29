# frozen_string_literal: true

require "pragmater"

module Rubysmith
  module Extensions
    # Ensures project skeleton has pragmas.
    class Pragmater
      def self.call(...) = new(...).call

      def initialize configuration,
                     client: ::Pragmater::Runner.new,
                     content: ::Pragmater::Configuration::Content
        @configuration = configuration
        @client = client
        @content = content
      end

      def call = client.call(settings) && configuration

      private

      attr_reader :configuration, :client, :content

      def settings
        content[
          action_insert: true,
          comments: configuration.extensions_pragmater_comments,
          includes: configuration.extensions_pragmater_includes,
          root_dir: configuration.project_root
        ]
      end
    end
  end
end
