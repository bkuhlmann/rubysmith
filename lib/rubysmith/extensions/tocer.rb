# frozen_string_literal: true

require "refinements/structs"
require "tocer"

module Rubysmith
  module Extensions
    # Ensures project skeleton documentation has table of contents.
    class Tocer
      using Refinements::Structs

      def self.call(...) = new(...).call

      def initialize configuration,
                     client: ::Tocer::Runner.new,
                     content: ::Tocer::Configuration::Content.new
        @configuration = configuration
        @client = client
        @content = content
      end

      def call
        client.call settings if configuration.build_readme
        configuration
      end

      private

      attr_reader :configuration, :client, :content

      def settings
        content.merge(root_dir: configuration.project_root)
               .transmute! configuration,
                           includes: :extensions_tocer_includes,
                           label: :extensions_tocer_label
      end
    end
  end
end
