# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    # Builds project skeleton Rake support.
    class Rake < Abstract
      using Refinements::Struct

      def call
        return configuration unless configuration.build_rake

        add_binstub
        add_configuration
        configuration
      end

      private

      def add_binstub
        builder.call(configuration.merge(template_path: "%project_name%/bin/rake.erb"))
               .render
               .permit 0o755
      end

      def add_configuration
        builder.call(configuration.merge(template_path: "%project_name%/Rakefile.erb"))
               .render
               .replace(/\[\s+/, "[")
               .replace(/\s+\]/, "]")
               .replace("  ", "")
               .replace("task.options", "  task.options")
               .replace(/\n+(?=require)/, "\n")
               .replace(/\n{2,}/, "\n\n")
      end
    end
  end
end
