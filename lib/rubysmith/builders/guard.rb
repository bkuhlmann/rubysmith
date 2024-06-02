# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    # Builds project skeleton Guard support for a red, green, refactor loop.
    class Guard < Abstract
      using Refinements::Struct

      def call
        return settings unless settings.build_guard

        builder.call(settings.merge(template_path: "%project_name%/bin/guard.erb"))
               .render
               .permit 0o755

        builder.call(settings.merge(template_path: "%project_name%/Guardfile.erb")).render
        settings
      end
    end
  end
end
