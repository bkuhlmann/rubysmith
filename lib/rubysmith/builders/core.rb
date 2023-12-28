# frozen_string_literal: true

require "refinements/string"
require "refinements/struct"

module Rubysmith
  module Builders
    # Builds project skeleton core structure and minimum file support.
    class Core
      using Refinements::String
      using Refinements::Struct

      def self.call(...) = new(...).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        render_implementation
        render_specification
        configuration
      end

      private

      def render_implementation
        builder.call(configuration.merge(template_path: "%project_name%/lib/%project_path%.rb.erb"))
               .render
               .replace("  require", "require")
               .replace(/    (?=(Zeit|loader|end))/, "")
               .replace("\n  \n", "\n\n")
               .insert_before("module #{module_name}", "#{indentation}# Main namespace.\n")
      end

      def render_specification
        return unless configuration.build_zeitwerk

        path = "%project_name%/spec/lib/%project_path%_spec.rb.erb"
        builder.call(configuration.merge(template_path: path)).render
      end

      def indentation = ::Core::EMPTY_STRING.indent configuration.project_levels

      def module_name = configuration.project_class

      attr_reader :configuration, :builder
    end
  end
end
