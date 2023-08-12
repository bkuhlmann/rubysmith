# frozen_string_literal: true

require "refinements/structs"

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton README documentation.
      class Readme
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return configuration unless configuration.build_readme

          builder.call(configuration.merge(template_path: "%project_name%/README.#{kind}.erb"))
                 .render
                 .replace(/\n{2,}/, "\n\n")
                 .replace("\n    \n", "\n")

          configuration
        end

        private

        attr_reader :configuration, :builder

        def kind = configuration.documentation_format
      end
    end
  end
end
