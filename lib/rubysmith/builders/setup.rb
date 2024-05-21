# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    # Builds project skeleton setup script.
    class Setup < Abstract
      using Refinements::Struct

      def call
        return configuration unless configuration.build_setup

        builder.call(configuration.merge(template_path: "%project_name%/bin/setup.erb"))
               .render
               .permit 0o755

        configuration
      end
    end
  end
end
