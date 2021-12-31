# frozen_string_literal: true

require "refinements/structs"

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton citation documentation.
      class Citation
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return configuration unless configuration.build_citation

          builder.call(configuration.merge(template_path: "%project_name%/CITATION.cff.erb")).render
          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
