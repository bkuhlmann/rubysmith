# frozen_string_literal: true

require "tocer"
require "refinements/structs"

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton CONTRIBUTING documentation.
      class Contribution
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return configuration unless configuration.build_contributions

          builder.call(updated_configuration).render
          configuration
        end

        private

        attr_reader :configuration, :builder

        def updated_configuration
          configuration.merge template_path: "%project_name%/CONTRIBUTING.#{kind}.erb"
        end

        def kind = configuration.documentation_format
      end
    end
  end
end
