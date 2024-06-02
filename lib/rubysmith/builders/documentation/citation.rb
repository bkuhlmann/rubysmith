# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton citation documentation.
      class Citation < Abstract
        using Refinements::Struct

        def call
          return settings unless settings.build_citation

          builder.call(settings.merge(template_path: "%project_name%/CITATION.cff.erb")).render
          settings
        end
      end
    end
  end
end
