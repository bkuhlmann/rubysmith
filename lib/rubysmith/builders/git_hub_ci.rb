# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    # Builds project skeleton GitHub CI template.
    class GitHubCI < Abstract
      using Refinements::Struct

      def call
        return configuration unless configuration.build_git_hub_ci

        builder.call(configuration_with_template).render.replace(/\n\n\Z/, "\n")
        configuration
      end

      private

      def configuration_with_template
        configuration.merge template_path: "%project_name%/.github/workflows/ci.yml.erb"
      end
    end
  end
end
