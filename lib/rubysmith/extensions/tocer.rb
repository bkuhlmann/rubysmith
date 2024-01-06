# frozen_string_literal: true

require "tocer"

module Rubysmith
  module Extensions
    # Ensures project skeleton documentation has table of content.
    class Tocer
      def self.call(...) = new(...).call

      def initialize configuration, client: ::Tocer::Runner.new
        @configuration = configuration
        @client = client
      end

      def call
        client.call ::Tocer::Container[:configuration] if configuration.build_readme
        configuration
      end

      private

      attr_reader :configuration, :client
    end
  end
end
