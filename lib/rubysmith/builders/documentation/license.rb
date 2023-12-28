# frozen_string_literal: true

require "refinements/struct"
require "tocer"

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton LICENSE documentation.
      class License
        using Refinements::Struct

        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return configuration unless configuration.build_license

          configuration.merge(template_path: "%project_name%/LICENSE-#{license}.#{kind}.erb")
                       .then do |updated_configuration|
                         builder.call(updated_configuration).render.rename "LICENSE.#{kind}"
                       end

          configuration
        end

        private

        attr_reader :configuration, :builder

        def kind = configuration.documentation_format

        def license = configuration.license_name
      end
    end
  end
end
