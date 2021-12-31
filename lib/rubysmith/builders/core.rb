# frozen_string_literal: true

require "refinements/structs"

module Rubysmith
  module Builders
    # Builds project skeleton core structure and minimum file support.
    class Core
      using Refinements::Structs

      def self.call(...) = new(...).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        builder.call(configuration.merge(template_path: "%project_name%/lib/%project_path%.rb.erb"))
               .render
               .replace("  require", "require")
               .replace(/    (?=(Zeit|\.tap|\.setup))/, "")
               .replace("\n  \n", "\n\n")

        builder.call(configuration.merge(template_path: "%project_name%/.ruby-version.erb")).render
        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
