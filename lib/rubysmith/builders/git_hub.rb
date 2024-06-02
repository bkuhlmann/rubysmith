# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    # Builds project skeleton GitHub templates.
    class GitHub < Abstract
      using Refinements::Struct

      def call
        render_funding

        return settings unless settings.build_git_hub

        builder.call(with_issue_template).render
        builder.call(with_pull_request_template).render
        settings
      end

      private

      def render_funding
        return unless settings.build_funding

        settings.merge(template_path: "%project_name%/.github/FUNDING.yml.erb")
                .then { |updated_configuration| builder.call(updated_configuration).render }
      end

      def with_issue_template
        settings.merge template_path: "%project_name%/.github/ISSUE_TEMPLATE.md.erb"
      end

      def with_pull_request_template
        settings.merge template_path: "%project_name%/.github/PULL_REQUEST_TEMPLATE.md.erb"
      end
    end
  end
end
