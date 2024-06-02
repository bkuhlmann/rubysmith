# frozen_string_literal: true

require "bundler"
require "bundler/cli"
require "refinements/io"
require "refinements/pathname"

module Rubysmith
  module Extensions
    # Ensures gem dependencies are installed.
    class Bundler
      include Import[:settings]

      using Refinements::IO
      using Refinements::Pathname

      def self.call(...) = new(...).call

      def initialize(client: ::Bundler::CLI, **)
        @client = client
        super(**)
      end

      def call
        settings.project_root.change_dir do
          client.start %w[install --quiet]
          STDOUT.squelch { client.start %w[lock --add-platform x86_64-linux --update] }
        end

        settings
      end

      private

      attr_reader :client
    end
  end
end
