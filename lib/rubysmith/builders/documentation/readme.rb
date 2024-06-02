# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton README documentation.
      class Readme < Abstract
        using Refinements::Struct

        def call
          return settings unless settings.build_readme

          builder.call(settings.merge(template_path: "%project_name%/README.#{kind}.erb"))
                 .render
                 .replace(/\n{2,}/, "\n\n")
                 .replace("\n    \n", "\n")

          settings
        end

        protected

        def kind = settings.documentation_format
      end
    end
  end
end
