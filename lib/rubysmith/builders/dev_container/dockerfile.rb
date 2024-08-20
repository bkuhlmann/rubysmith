# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module DevContainer
      # Builds Dockerfile for container.
      class Dockerfile < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_devcontainer

          builder.call(settings.merge(template_path: "%project_name%/.devcontainer/Dockerfile.erb"))
                 .render
          true
        end
      end
    end
  end
end
