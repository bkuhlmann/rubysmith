# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module DevContainer
      # Builds container configuration.
      class Configuration < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_devcontainer

          path = "%project_name%/.devcontainer/devcontainer.json.erb"
          builder.call(settings.merge(template_path: path)).render
          true
        end
      end
    end
  end
end
