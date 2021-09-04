# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds project skeleton documentation.
    class Documentation
      def self.call(...) = new(...).call

      def initialize configuration, builder: Builder
        @configuration = configuration
        @builder = builder
      end

      def call
        return unless configuration.build_documentation

        private_methods.sort.grep(/render_/).each { |method| __send__ method }
      end

      private

      attr_reader :configuration, :builder

      def render_changes
        builder.call(configuration.with(template_path: "%project_name%/CHANGES.#{kind}.erb"))
               .render
      end

      def render_conduct
        configuration.with(template_path: "%project_name%/CODE_OF_CONDUCT.#{kind}.erb")
                     .then { |updated_configuration| builder.call(updated_configuration).render }
      end

      def render_contributions
        builder.call(configuration.with(template_path: "%project_name%/CONTRIBUTING.#{kind}.erb"))
               .render
      end

      def render_license
        configuration.with(template_path: "%project_name%/LICENSE-#{license}.#{kind}.erb")
                     .then do |updated_configuration|
                       builder.call(updated_configuration).render.rename "LICENSE.#{kind}"
                     end
      end

      def render_readme
        builder.call(configuration.with(template_path: "%project_name%/README.#{kind}.erb"))
               .render
               .replace("\n\n\n", "\n\n")
      end

      def kind = configuration.documentation_format || "md"

      def license = configuration.documentation_license || "mit"
    end
  end
end
