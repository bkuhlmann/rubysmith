# frozen_string_literal: true

require "refinements/struct"
require "tocer"

module Rubysmith
  module Extensions
    # Ensures project skeleton documentation has table of content.
    class Tocer
      using Refinements::Struct

      def self.call(...) = new(...).call

      def initialize configuration,
                     client: ::Tocer::Runner.new,
                     record: ::Tocer::Configuration::Model.new
        @configuration = configuration
        @client = client
        @record = record
      end

      def call
        client.call settings if configuration.build_readme
        configuration
      end

      private

      attr_reader :configuration, :client, :record

      def settings
        record.merge(root_dir: configuration.project_root)
              .transmute! configuration,
                          label: :extensions_tocer_label,
                          patterns: :extensions_tocer_patterns
      end
    end
  end
end
