# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Docker
      # Builds Dockerfile configuration.
      class File < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_docker

          builder.call(settings.with(template_path: "%project_name%/Dockerfile.erb")).render
          true
        end
      end
    end
  end
end
