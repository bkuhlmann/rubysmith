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
          return false unless settings.build_versions

          builder.call(settings.with(template_path: "%project_name%/VERSIONS.#{kind}.erb")).render

          true
        end

        private

        def kind = settings.documentation_format
      end
    end
  end
end
