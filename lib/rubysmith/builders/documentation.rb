# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds project skeleton documentation.
    class Documentation
      def self.call realm, builder: Builder
        new(realm, builder: builder).call
      end

      def initialize realm, builder: Builder
        @realm = realm
        @builder = builder
      end

      def call
        return unless realm.build_documentation

        private_methods.grep(/render_/).each { |method| __send__ method }
      end

      private

      attr_reader :realm, :builder

      def render_changes
        builder.call(realm.with(template_path: "%project_name%/CHANGES.#{kind}.erb"))
               .render
      end

      def render_conduct
        builder.call(realm.with(template_path: "%project_name%/CODE_OF_CONDUCT.#{kind}.erb"))
               .render
      end

      def render_contributions
        builder.call(realm.with(template_path: "%project_name%/CONTRIBUTING.#{kind}.erb"))
               .render
      end

      def render_license
        builder.call(realm.with(template_path: "%project_name%/LICENSE-#{license}.#{kind}.erb"))
               .render
               .rename "LICENSE.#{kind}"
      end

      def render_readme
        builder.call(realm.with(template_path: "%project_name%/README.#{kind}.erb"))
               .render
               .replace("\n\n\n", "\n\n")
      end

      def kind
        realm.documentation_format || "md"
      end

      def license
        realm.documentation_license || "mit"
      end
    end
  end
end
