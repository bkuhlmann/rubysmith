# frozen_string_literal: true

require "refinements/pathname"
require "tocer"

module Rubysmith
  module Extensions
    # Ensures project skeleton documentation has table of content.
    class Tocer
      include Import[:settings]

      using Refinements::Pathname

      def initialize(client: ::Tocer::Runner.new, **)
        @client = client
        super(**)
      end

      def call
        return false unless settings.build_readme

        settings.project_root.change_dir { client.call }
        true
      end

      private

      attr_reader :client
    end
  end
end
