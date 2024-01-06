# frozen_string_literal: true

require "milestoner"

module Rubysmith
  module Extensions
    # Ensures project can be published (tagged) in a reliable and consistent fashion.
    class Milestoner
      def self.call(...) = new(...).call

      def initialize configuration, client: ::Milestoner::Tags::Publisher.new
        @configuration = configuration
        @client = client
      end

      def call = client.call(configuration.project_version) && configuration

      private

      attr_reader :configuration, :client
    end
  end
end
