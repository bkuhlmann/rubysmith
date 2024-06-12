# frozen_string_literal: true

require "pragmater"
require "refinements/pathname"

module Rubysmith
  module Extensions
    # Ensures project skeleton has pragmas.
    class Pragmater
      include Import[:settings]

      using Refinements::Pathname

      CLIENT = ::Pragmater::Inserter.new(
        settings: ::Pragmater::Configuration::Model[
          comments: ["# frozen_string_literal: true"],
          patterns: %w[**/*.rake **/*.rb *.gemspec exe/* bin/* config.ru *file]
        ]
      ).freeze

      def initialize(client: CLIENT, **)
        @client = client
        super(**)
      end

      def call
        settings.project_root.change_dir { client.call }
        true
      end

      private

      attr_reader :client
    end
  end
end
