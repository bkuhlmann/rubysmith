# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    module GitHub
      # Builds project skeleton GitHub templates.
      class Template < Abstract
        using Refinements::Struct

        def call
          return false unless settings.build_git_hub

          builder.call(with_issue).render
          builder.call(with_pull_request).render
          builder.call(with_configuration).render
          true
        end

        private

        def with_issue
          settings.merge template_path: "%project_name%/.github/ISSUE_TEMPLATE/issue.md.erb"
        end

        def with_pull_request
          settings.merge template_path: "%project_name%/.github/PULL_REQUEST_TEMPLATE.md.erb"
        end

        def with_configuration
          settings.merge template_path: "%project_name%/.github/ISSUE_TEMPLATE/config.yml.erb"
        end
      end
    end
  end
end
