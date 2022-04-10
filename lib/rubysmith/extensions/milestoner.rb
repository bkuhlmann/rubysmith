# frozen_string_literal: true

require "milestoner"
require "refinements/structs"

module Rubysmith
  module Extensions
    # Ensures project can be published (tagged) in a reliable and consistent fashion.
    class Milestoner
      using Refinements::Structs

      def self.call(...) = new(...).call

      def initialize configuration,
                     client: ::Milestoner::Tags::Publisher.new,
                     content: ::Milestoner::Configuration::Content.new
        @configuration = configuration
        @client = client
        @content = content
      end

      def call = client.call(settings) && configuration

      private

      attr_reader :configuration, :client, :content

      def settings
        content.transmute configuration,
                          documentation_format: :extensions_milestoner_documentation_format,
                          prefixes: :extensions_milestoner_prefixes,
                          version: :project_version
      end
    end
  end
end
