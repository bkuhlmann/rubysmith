# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds project skeleton with Rubocop code quality support.
    class Rubocop
      def self.call(...) = new(...).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        return configuration unless configuration.build_rubocop

        builder.call(configuration.with(template_path: "%project_name%/bin/rubocop.erb"))
               .render
               .permit 0o755

        builder.call(configuration.with(template_path: "%project_name%/.rubocop.yml.erb")).render
        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
