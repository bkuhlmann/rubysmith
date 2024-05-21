# frozen_string_literal: true

require "refinements/struct"
require "tocer"

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton version history.
      class Version < Abstract
        using Refinements::Struct

        def call
          return configuration unless configuration.build_versions

          builder.call(configuration.merge(template_path: "%project_name%/VERSIONS.#{kind}.erb"))
                 .render

          configuration
        end

        private

        def kind = configuration.documentation_format
      end
    end
  end
end
