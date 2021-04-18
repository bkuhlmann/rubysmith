# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds project skeleton Guard support for a red, green, refactor loop.
    class Guard
      def self.call(configuration, builder: Builder) = new(configuration, builder: builder).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        return unless configuration.build_guard

        builder.call(configuration.with(template_path: "%project_name%/bin/guard.erb"))
               .render
               .permit 0o755
        builder.call(configuration.with(template_path: "%project_name%/Guardfile.erb")).render
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
