# frozen_string_literal: true

require "tocer"

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton README documentation.
      class Readme
        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return configuration unless configuration.build_readme

          builder.call(configuration.with(template_path: "%project_name%/README.#{kind}.erb"))
                 .render
                 .replace("\n\n\n", "\n\n")
                 .replace("\n\n\n\n\n", "\n\n")

          configuration
        end

        private

        attr_reader :configuration, :builder

        def kind = configuration.documentation_format
      end
    end
  end
end
