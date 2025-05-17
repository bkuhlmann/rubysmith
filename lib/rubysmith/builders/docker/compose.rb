# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Docker
      # Builds Docker compose configuration.
      class Compose < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_docker

          builder.call(settings.merge(template_path: "%project_name%/compose.yml.erb")).render
          true
        end
      end
    end
  end
end
