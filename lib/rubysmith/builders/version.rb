# frozen_string_literal: true

require "refinements/structs"

module Rubysmith
  module Builders
    # Builds project skeleton Ruby version file.
    class Version
      using Refinements::Structs

      def self.call(...) = new(...).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        builder.call(configuration.merge(template_path: "%project_name%/.ruby-version.erb"))
               .render
               .append("\n")
        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
