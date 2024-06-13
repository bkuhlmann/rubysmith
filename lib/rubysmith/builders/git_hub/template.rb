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
          builder.call(with_code_review).render
          true
        end

        private

        def with_issue
          settings.merge template_path: "%project_name%/.github/ISSUE_TEMPLATE.md.erb"
        end

        def with_code_review
          settings.merge template_path: "%project_name%/.github/PULL_REQUEST_TEMPLATE.md.erb"
        end
      end
    end
  end
end
