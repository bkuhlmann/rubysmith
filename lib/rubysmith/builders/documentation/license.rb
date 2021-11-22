# frozen_string_literal: true

require "tocer"

module Rubysmith
  module Builders
    module Documentation
      # Builds project skeleton LICENSE documentation.
      class License
        def self.call(...) = new(...).call

        def initialize configuration, builder: Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          return unless configuration.build_license

          configuration.with(template_path: "%project_name%/LICENSE-#{license}.#{kind}.erb")
                       .then do |updated_configuration|
                         builder.call(updated_configuration).render.rename "LICENSE.#{kind}"
                       end
        end

        private

        attr_reader :configuration, :builder

        def kind = configuration.documentation_format

        def license = configuration.license_name
      end
    end
  end
end
