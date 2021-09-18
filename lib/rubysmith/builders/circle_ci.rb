# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds project skeleton Circle CI configuration.
    class CircleCI
      def self.call(...) = new(...).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        return unless configuration.build_circle_ci

        builder.call(configuration.with(template_path: "%project_name%/.circleci/config.yml.erb"))
               .render
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
