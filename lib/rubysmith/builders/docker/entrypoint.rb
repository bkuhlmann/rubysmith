# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Docker
      # Builds Docker entrypoint script.
      class Entrypoint < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_docker

          builder.call(settings.with(template_path: "%project_name%/bin/docker/entrypoint.erb"))
                 .render
                 .permit 0o755

          true
        end
      end
    end
  end
end
