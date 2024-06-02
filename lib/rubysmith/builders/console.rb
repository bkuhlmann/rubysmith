# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    # Builds project skeleton console for object inspection and exploration.
    class Console < Abstract
      using Refinements::Struct

      def call
        return settings unless settings.build_console

        builder.call(settings.merge(template_path: "%project_name%/bin/console.erb"))
               .render
               .permit 0o755

        settings
      end
    end
  end
end
