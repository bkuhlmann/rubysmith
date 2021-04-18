# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds project skeleton Guard support for a red, green, refactor loop.
    class Guard
      def self.call(realm, builder: Builder) = new(realm, builder: builder).call

      def initialize realm, builder: Builder
        @realm = realm
        @builder = builder
      end

      def call
        return unless realm.build_guard

        builder.call(realm.with(template_path: "%project_name%/bin/guard.erb")).render.permit 0o755
        builder.call(realm.with(template_path: "%project_name%/Guardfile.erb")).render
      end

      private

      attr_reader :realm, :builder
    end
  end
end
