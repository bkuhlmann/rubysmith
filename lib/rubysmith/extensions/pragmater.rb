# frozen_string_literal: true

require "pragmater"
require "refinements/pathname"

module Rubysmith
  module Extensions
    # Ensures project skeleton has pragmas.
    class Pragmater
      using Refinements::Pathname

      def self.call(...) = new(...).call

      def self.custom_configuration
        ::Pragmater::Configuration::Model[
          comments: ["# frozen_string_literal: true"],
          patterns: %w[**/*.rake **/*.rb *.gemspec exe/* bin/* config.ru *file]
        ]
      end

      def initialize configuration, client: ::Pragmater::Inserter.new
        @configuration = configuration
        @client = client
      end

      def call
        configuration.project_root.change_dir { client.call self.class.custom_configuration }
        configuration
      end

      private

      attr_reader :configuration, :client
    end
  end
end
