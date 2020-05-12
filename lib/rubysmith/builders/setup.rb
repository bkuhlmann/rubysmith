# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds project skeleton setup script.
    class Setup
      def self.call realm, builder: Builder
        new(realm, builder: builder).call
      end

      def initialize realm, builder: Builder
        @realm = realm
        @builder = builder
      end

      def call
        return unless realm.build_setup

        builder.call(realm.with(template_path: "%project_name%/bin/setup.erb")).render.permit 0o755
      end

      private

      attr_reader :realm, :builder
    end
  end
end
