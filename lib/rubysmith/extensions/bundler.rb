# frozen_string_literal: true

require "bundler"
require "bundler/cli"
require "refinements/io"
require "refinements/pathname"

module Rubysmith
  module Extensions
    # Ensures gem dependencies are installed.
    class Bundler
      include Import[:settings, :logger]

      using Refinements::IO
      using Refinements::Pathname

      def initialize(client: ::Bundler::CLI, **)
        @client = client
        super(**)
      end

      def call
        logger.info { "Installing gem dependencies..." }
        install
      rescue ::Bundler::HTTPError
        log_error
      end

      private

      attr_reader :client

      def install
        settings.project_root.change_dir do
          client.start %w[install --quiet]
          STDOUT.squelch { client.start %w[lock --add-platform x86_64-linux --update] }
        end

        true
      end

      def log_error
        logger.error { "Unable to install gem dependencies. Is your network stable?" }
        false
      end
    end
  end
end
