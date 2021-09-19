# frozen_string_literal: true

require "tocer"

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton CONTRIBUTING documentation.
      class Contribution
        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return unless configuration.build_contributions

          builder.call(configuration.with(template_path: "%project_name%/CONTRIBUTING.#{kind}.erb"))
                 .render
        end

        private

        attr_reader :configuration, :builder

        def kind = configuration.documentation_format || "md"
      end
    end
  end
end
