# frozen_string_literal: true

require "pathname"
require "refinements/structs"

module Rubysmith
  module Builders
    # Initializes building of project by checking for existence first.
    class Init
      using Refinements::Structs

      def self.call(...) = new(...).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        builder.call(configuration.merge(template_path: "%project_name%")).check
        configuration
      end

      private

      attr_reader :configuration, :builder
    end
  end
end
