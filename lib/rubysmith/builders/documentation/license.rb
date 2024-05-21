# frozen_string_literal: true

require "refinements/struct"
require "tocer"

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton LICENSE documentation.
      class License < Abstract
        using Refinements::Struct

        def call
          return configuration unless configuration.build_license

          configuration.merge(template_path: "%project_name%/LICENSE-#{license}.#{kind}.erb")
                       .then do |updated_configuration|
                         builder.call(updated_configuration).render.rename "LICENSE.#{kind}"
                       end

          configuration
        end

        private

        def kind = configuration.documentation_format

        def license = configuration.license_name
      end
    end
  end
end
