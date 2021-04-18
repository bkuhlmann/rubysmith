# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds project skeleton console for object inspection and exploration.
    class Console
      def self.call(realm, builder: Builder) = new(realm, builder: builder).call

      def initialize realm, builder: Builder
        @realm = realm
        @builder = builder
      end

      def call
        return unless realm.build_console

        builder.call(realm.with(template_path: "%project_name%/bin/console.erb"))
               .render
               .permit 0o755
      end

      private

      attr_reader :realm, :builder
    end
  end
end
