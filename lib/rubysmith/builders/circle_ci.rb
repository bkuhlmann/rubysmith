# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    # Builds project skeleton Circle CI configuration.
    class CircleCI < Abstract
      using Refinements::Struct

      def call
        return settings unless settings.build_circle_ci

        builder.call(settings.merge(template_path: "%project_name%/.circleci/config.yml.erb"))
               .render
               .replace(/\n\n\Z/, "\n")

        settings
      end
    end
  end
end
