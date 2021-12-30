# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds Bundler Gemfile configuration for project skeleton.
    class Bundler
      def self.call(...) = new(...).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
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

        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
