# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    # Builds project skeleton GitHub CI template.
    class GitHubCI < Abstract
      using Refinements::Struct

      def call
        return settings unless settings.build_git_hub_ci

        builder.call(configuration_with_template).render.replace(/\n\n\Z/, "\n")
        settings
      end

      private

      def configuration_with_template
        settings.merge template_path: "%project_name%/.github/workflows/ci.yml.erb"
      end
    end
  end
end
