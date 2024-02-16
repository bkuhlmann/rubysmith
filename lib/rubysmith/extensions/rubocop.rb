# frozen_string_literal: true

require "refinements/io"
require "refinements/pathname"
require "rubocop"

module Rubysmith
  module Extensions
    # Ensures project skeleton adheres to style guide.
    class Rubocop
      using Refinements::IO
      using Refinements::Pathname

      def self.call(...) = new(...).call

      def initialize configuration, client: ::RuboCop::CLI.new
        @configuration = configuration
        @client = client
      end

      def call
        project_root = configuration.project_root

        project_root.change_dir do
          STDOUT.squelch { client.run ["--autocorrect-all", project_root.to_s] }
        end

        configuration
      end

      private

      attr_reader :configuration, :client
    end
  end
end
