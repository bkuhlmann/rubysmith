# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton citation documentation.
      class Citation < Abstract
        using Refinements::Struct

        def call
          return configuration unless configuration.build_citation

          builder.call(configuration.merge(template_path: "%project_name%/CITATION.cff.erb")).render
          configuration
        end
      end
    end
  end
end
