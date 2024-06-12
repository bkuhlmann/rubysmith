# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton LICENSE documentation.
      class License < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_license

          settings.merge(template_path: "%project_name%/LICENSE-#{license}.#{kind}.erb")
                  .then do |updated_settings|
                    builder.call(updated_settings).render.rename "LICENSE.#{kind}"
                  end

          true
        end

        private

        def kind = settings.documentation_format

        def license = settings.license_name
      end
    end
  end
end
