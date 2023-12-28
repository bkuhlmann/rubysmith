# frozen_string_literal: true

require "pragmater"
require "refinements/struct"

module Rubysmith
  module Extensions
    # Ensures project skeleton has pragmas.
    class Pragmater
      using Refinements::Struct

      def self.call(...) = new(...).call

      def initialize configuration,
                     client: ::Pragmater::Inserter.new,
                     record: ::Pragmater::Configuration::Model.new
        @configuration = configuration
        @client = client
        @record = record
      end

      def call = client.call(settings) && configuration

      private

      attr_reader :configuration, :client, :record

      def settings
        record.merge(root_dir: configuration.project_root)
              .transmute! configuration,
                          comments: :extensions_pragmater_comments,
                          patterns: :extensions_pragmater_patterns
      end
    end
  end
end
