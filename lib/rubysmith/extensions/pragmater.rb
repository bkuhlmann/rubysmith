# frozen_string_literal: true

require "pragmater"

module Rubysmith
  module Extensions
    # Ensures project skeleton has pragmas.
    class Pragmater
      def self.call(...) = new(...).call

      def initialize configuration, client: ::Pragmater::Inserter.new
        @configuration = configuration
        @client = client
      end

      def call = client.call && configuration

      private

      attr_reader :configuration, :client
    end
  end
end
