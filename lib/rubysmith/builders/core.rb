# frozen_string_literal: true

require "refinements/strings"
require "refinements/structs"

module Rubysmith
  module Builders
    # Builds project skeleton core structure and minimum file support.
    class Core
      using Refinements::Strings
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
               .insert_before("module #{module_name}", "#{indentation}# Main namespace.\n")
               .replace("end\n  end", "    end\n  end")

        configuration
      end

      private

      def indentation = "".indent configuration.project_levels

      def module_name = configuration.project_class.split("::").last

      attr_reader :configuration, :builder
    end
  end
end
