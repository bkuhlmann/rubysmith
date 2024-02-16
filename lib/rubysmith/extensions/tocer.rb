# frozen_string_literal: true

require "refinements/pathname"
require "tocer"

module Rubysmith
  module Extensions
    # Ensures project skeleton documentation has table of content.
    class Tocer
      using Refinements::Pathname

      def self.call(...) = new(...).call

      def initialize configuration, client: ::Tocer::Runner.new
        @configuration = configuration
        @client = client
      end

      def call
        return configuration unless configuration.build_readme

        configuration.project_root.change_dir { client.call ::Tocer::Container[:configuration] }
        configuration
      end

      private

      attr_reader :configuration, :client
    end
  end
end
