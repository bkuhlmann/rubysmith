# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    # Builds project skeleton with Caliber style support.
    class Caliber < Abstract
      using Refinements::Struct

      def call
        return configuration unless configuration.build_caliber

        builder.call(configuration.merge(template_path: "%project_name%/bin/rubocop.erb"))
               .render
               .permit 0o755

        path = "%project_name%/.config/rubocop/config.yml.erb"
        builder.call(configuration.merge(template_path: path)).render
        configuration
      end
    end
  end
end
