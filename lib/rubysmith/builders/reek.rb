# frozen_string_literal: true

require "refinements/structs"

module Rubysmith
  module Builders
    # Builds project skeleton Reek code quality support.
    class Reek
      using Refinements::Structs

      def self.call(...) = new(...).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        return configuration unless configuration.build_reek

        builder.call(configuration.merge(template_path: "%project_name%/.reek.yml.erb")).render
        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
