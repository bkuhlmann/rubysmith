# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds project skeleton console for object inspection and exploration.
    class Console
      def self.call(...) = new(...).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        return unless configuration.build_console

        builder.call(configuration.with(template_path: "%project_name%/bin/console.erb"))
               .render
               .permit 0o755
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
