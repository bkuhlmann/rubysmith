# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module DevContainer
      # Builds Docker Compose configuration for container.
      class Compose < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_devcontainer

          path = "%project_name%/.devcontainer/compose.yaml.erb"
          builder.call(settings.with(template_path: path)).render
          true
        end
      end
    end
  end
end
