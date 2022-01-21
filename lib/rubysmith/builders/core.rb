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
               .replace(/    (?=(Zeit|loader|end))/, "")
               .replace("\n  \n", "\n\n")
               .insert_before("module #{module_name}", "#{module_indent}# Main namespace.\n")

        builder.call(configuration.merge(template_path: "%project_name%/.ruby-version.erb")).render
        configuration
      end

      private

      def module_indent = project_class.include?("::") ? "  " : ""

      def module_name = project_class.split("::").last

      def project_class = configuration.project_class

      attr_reader :configuration, :builder
    end
  end
end
