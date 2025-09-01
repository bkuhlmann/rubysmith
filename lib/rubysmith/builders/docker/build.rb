# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Docker
      # Builds Docker build script.
      class Build < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_docker

          builder.call(settings.with(template_path: "%project_name%/bin/docker/build.erb"))
                 .render
                 .permit 0o755

          true
        end
      end
    end
  end
end
