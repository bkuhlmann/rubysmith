# frozen_string_literal: true

require "pragmater"
require "refinements/pathname"

module Rubysmith
  module Extensions
    # Ensures project skeleton has pragmas.
    class Pragmater
      include Dependencies[:settings, :logger]

      using Refinements::Pathname

      CLIENT = ::Pragmater::Inserter.new(
        settings: ::Pragmater::Configuration::Model[
          comments: ["# frozen_string_literal: true"],
          patterns: %w[
            **/*.rake
            **/*.rb
            *.gemspec
            exe/*
            bin/console
            bin/rake
            bin/rspec
            bin/rubocop
            bin/setup
            config.ru
            Gemfile
            Rakefile
          ]
        ]
      ).freeze

      def initialize(client: CLIENT, **)
        @client = client
        super(**)
      end

      def call
        logger.info { "Adding frozen string literal pragmas..." }
        settings.project_root.change_dir { client.call }
        true
      end

      private

      attr_reader :client
    end
  end
end
