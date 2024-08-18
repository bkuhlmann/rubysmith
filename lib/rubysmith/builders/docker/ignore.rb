# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module Docker
      # Builds Docker ignore configuration.
      class Ignore < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_git

          builder.call(settings.merge(template_path: "%project_name%/.dockerignore.erb")).render
          true
        end
      end
    end
  end
end
