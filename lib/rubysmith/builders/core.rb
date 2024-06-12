# frozen_string_literal: true

require "refinements/string"
require "refinements/struct"

module Rubysmith
  module Builders
    # Builds project skeleton core structure and minimum file support.
    class Core < Abstract
      using Refinements::String
      using Refinements::Struct

      def call
        render_implementation
        render_specification
        true
      end

      private

      def render_implementation
        builder.call(settings.merge(template_path: "%project_name%/lib/%project_path%.rb.erb"))
               .render
               .replace("  require", "require")
               .replace(/    (?=(Zeit|loader|end))/, "")
               .replace("\n  \n", "\n\n")
               .insert_before("module #{module_name}", "#{indentation}# Main namespace.\n")
      end

      def render_specification
        return unless settings.build_zeitwerk

        path = "%project_name%/spec/lib/%project_path%_spec.rb.erb"
        builder.call(settings.merge(template_path: path)).render
      end

      def indentation = ::Core::EMPTY_STRING.indent settings.project_levels

      def module_name = settings.project_class
    end
  end
end
