# frozen_string_literal: true

require "tocer"

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton CODE_OF_CONDUCT documentation.
      class Conduct
        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return configuration unless configuration.build_conduct

          configuration.with(template_path: "%project_name%/CODE_OF_CONDUCT.#{kind}.erb")
                       .then { |updated_configuration| builder.call(updated_configuration).render }

          configuration
        end

        private

        attr_reader :configuration, :builder

        def kind = configuration.documentation_format
      end
    end
  end
end
