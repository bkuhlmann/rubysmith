# frozen_string_literal: true

require "refinements/io"
require "refinements/pathname"
require "rubocop"

module Rubysmith
  module Extensions
    # Ensures project skeleton adheres to style guide.
    class Rubocop
      include Import[:settings]

      using Refinements::IO
      using Refinements::Pathname

      def initialize(client: ::RuboCop::CLI.new, **)
        @client = client
        super(**)
      end

      def call
        project_root = settings.project_root

        project_root.change_dir do
          STDOUT.squelch { client.run ["--autocorrect-all", project_root.to_s] }
        end

        true
      end

      private

      attr_reader :client
    end
  end
end
