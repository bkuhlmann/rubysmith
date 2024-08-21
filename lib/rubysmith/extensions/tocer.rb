# frozen_string_literal: true

require "refinements/pathname"
require "stringio"
require "tocer"

module Rubysmith
  module Extensions
    # Ensures project skeleton documentation has table of content.
    class Tocer
      include Import[:settings, :logger]

      using Refinements::Pathname

      def initialize(client: ::Tocer::Runner.new(io: StringIO.new), **)
        @client = client
        super(**)
      end

      def call
        return false unless settings.build_readme && settings.markdown?

        logger.info { "Adding table of contents..." }
        upsert
        true
      end

      private

      attr_reader :client

      def upsert = settings.project_root.change_dir { client.call }
    end
  end
end
