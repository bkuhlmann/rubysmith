# frozen_string_literal: true

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton citation documentation.
      class Citation
        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return unless configuration.build_citation

          builder.call(configuration.with(template_path: "%project_name%/CITATION.cff.erb")).render
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
