# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    # Builds project skeleton setup script.
    class Setup < Abstract
      using Refinements::Struct

      def call
        return settings unless settings.build_setup

        builder.call(settings.merge(template_path: "%project_name%/bin/setup.erb"))
               .render
               .permit 0o755

        settings
      end
    end
  end
end
