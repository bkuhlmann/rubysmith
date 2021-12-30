# frozen_string_literal: true

require "milestoner"

module Rubysmith
  module Extensions
    # Ensures project can be published (tagged) in a reliable and consistent fashion.
    class Milestoner
      def self.call(...) = new(...).call

      def initialize configuration,
                     client: ::Milestoner::Tags::Publisher.new,
                     content: ::Milestoner::Configuration::Content
        @configuration = configuration
        @client = client
        @content = content
      end

      def call = client.call(settings) && configuration

      private

      attr_reader :configuration, :client, :content

      def settings
        content[
          documentation_format: configuration.extensions_milestoner_documentation_format,
          prefixes: configuration.extensions_milestoner_prefixes,
          sign: configuration.extensions_milestoner_sign,
          version: configuration.project_version
        ]
      end
    end
  end
end
