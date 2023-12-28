# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    # Builds project skeleton GitHub CI template.
    class GitHubCI
      using Refinements::Struct

      def self.call(...) = new(...).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        return configuration unless configuration.build_git_hub_ci

        builder.call(configuration_with_template).render.replace(/\n\n\Z/, "\n")
        configuration
      end

      private

      attr_reader :configuration, :builder

      def configuration_with_template
        configuration.merge template_path: "%project_name%/.github/workflows/ci.yml.erb"
      end
    end
  end
end
