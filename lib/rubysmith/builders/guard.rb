# frozen_string_literal: true

require "refinements/struct"

module Rubysmith
  module Builders
    # Builds project skeleton Guard support for a red, green, refactor loop.
    class Guard
      using Refinements::Struct

      def self.call(...) = new(...).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        return configuration unless configuration.build_guard

        builder.call(configuration.merge(template_path: "%project_name%/bin/guard.erb"))
               .render
               .permit 0o755

        builder.call(configuration.merge(template_path: "%project_name%/Guardfile.erb")).render
        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
