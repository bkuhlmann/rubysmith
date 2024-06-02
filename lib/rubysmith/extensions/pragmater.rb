# frozen_string_literal: true

require "pragmater"
require "refinements/pathname"

module Rubysmith
  module Extensions
    # Ensures project skeleton has pragmas.
    class Pragmater
      include Import[:settings]

      using Refinements::Pathname

      CONFIGURATION = ::Pragmater::Configuration::Model[
        comments: ["# frozen_string_literal: true"],
        patterns: %w[**/*.rake **/*.rb *.gemspec exe/* bin/* config.ru *file]
      ].freeze

      def self.call(...) = new(...).call

      def initialize(configuration = CONFIGURATION, client: ::Pragmater::Inserter.new, **)
        @configuration = configuration
        @client = client
        super(**)
      end

      def call
        settings.project_root.change_dir { client.call configuration }
        settings
      end

      private

      attr_reader :configuration, :client
    end
  end
end
