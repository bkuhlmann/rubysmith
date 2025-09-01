# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module GitHub
      # Builds project skeleton GitHub CI template.
      class CI < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_git_hub_ci

          builder.call(with_template).render.replace(/\n\n\Z/, "\n")
          true
        end

        private

        def with_template
          settings.with template_path: "%project_name%/.github/workflows/ci.yml.erb"
        end
      end
    end
  end
end
