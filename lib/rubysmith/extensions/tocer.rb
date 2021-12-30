# frozen_string_literal: true

require "tocer"

module Rubysmith
  module Extensions
    # Ensures project skeleton documentation has table of contents.
    class Tocer
      def self.call(...) = new(...).call

      def initialize configuration,
                     client: ::Tocer::Runner.new,
                     content: ::Tocer::Configuration::Content
        @configuration = configuration
        @client = client
        @content = content
      end

      def call
        client.call(settings) if configuration.build_readme
        configuration
      end

      private

      attr_reader :configuration, :client, :content

      def settings
        content[
          includes: configuration.extensions_tocer_includes,
          label: configuration.extensions_tocer_label,
          root_dir: configuration.project_root
        ]
      end
    end
  end
end
