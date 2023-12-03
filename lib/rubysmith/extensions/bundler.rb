# frozen_string_literal: true

require "bundler"
require "bundler/cli"
require "refinements/ios"
require "refinements/pathnames"

module Rubysmith
  module Extensions
    # Ensures gem dependencies are installed.
    class Bundler
      using Refinements::IOs
      using Refinements::Pathnames

      def self.call(...) = new(...).call

      def initialize configuration, client: ::Bundler::CLI
        @configuration = configuration
        @client = client
      end

      def call
        configuration.project_root.change_dir do
          client.start %w[install --quiet]
          STDOUT.squelch { client.start %w[lock --add-platform x86_64-linux --update] }
        end

        configuration
      end

      private

      attr_reader :configuration, :client
    end
  end
end
