# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton README documentation.
      class Readme < Abstract
        using Refinements::Struct

        def call
          return configuration unless configuration.build_readme

          builder.call(configuration.merge(template_path: "%project_name%/README.#{kind}.erb"))
                 .render
                 .replace(/\n{2,}/, "\n\n")
                 .replace("\n    \n", "\n")

          configuration
        end

        protected

        def kind = configuration.documentation_format
      end
    end
  end
end
