# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds project skeleton GitHub templates.
    class GitHub
      def self.call(...) = new(...).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        return unless configuration.build_git_hub

        builder.call(with_issue_template).render
        builder.call(with_pull_request_template).render
      end

      private

      attr_reader :configuration, :builder

      def with_issue_template
        configuration.with template_path: "%project_name%/.github/ISSUE_TEMPLATE.md.erb"
      end

      def with_pull_request_template
        configuration.with template_path: "%project_name%/.github/PULL_REQUEST_TEMPLATE.md.erb"
      end
    end
  end
end
