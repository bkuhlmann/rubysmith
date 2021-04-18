# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds project skeleton Reek code quality support.
    class Reek
      def self.call(configuration, builder: Builder) = new(configuration, builder: builder).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        return unless configuration.build_reek

        builder.call(configuration.with(template_path: "%project_name%/.reek.yml.erb")).render
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
