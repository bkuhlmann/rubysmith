# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton README documentation.
      class Readme < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_readme

          builder.call(settings.with(template_path: "%project_name%/README.#{kind}.erb"))
                 .render
                 .replace(/\n{2,}/, "\n\n")
                 .replace("\n    \n", "\n")

          true
        end

        protected

        def kind = settings.documentation_format
      end
    end
  end
end
