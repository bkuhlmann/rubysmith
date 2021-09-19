# frozen_string_literal: true

require "bundler"
require "bundler/cli"
require "refinements/pathnames"

module Rubysmith
  module Builders
    # Builds Bundler Gemfile configuration and installs gem dependencies for project skeleton.
    class Bundler
      using Refinements::Pathnames

      def self.call(...) = new(...).call

      def initialize configuration, builder: Builder, client: ::Bundler::CLI
        @configuration = configuration
        @builder = builder
        @client = client
      end

      def call
        builder.call(configuration.with(template_path: "%project_name%/Gemfile.erb"))
               .render
               .replace(/\n\s+group/, "\n\ngroup")
               .replace(/\n\s+gem/, "\n  gem")
               .replace(/  (?=.+(refinements|zeitwerk))/, "")
               .replace(/(\n+|\s+)end/, "\nend")
               .replace(/\n\ngroup :(code_quality|development|test|tools) do\nend/, "")
               .replace(/org"\n+/, "org\"\n\n")

        configuration.project_root.change_dir { client.start %w[install --quiet] }
        nil
      end

      private

      attr_reader :configuration, :builder, :client
    end
  end
end
