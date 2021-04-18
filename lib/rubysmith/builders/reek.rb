# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds project skeleton Reek code quality support.
    class Reek
      def self.call(realm, builder: Builder) = new(realm, builder: builder).call

      def initialize realm, builder: Builder
        @realm = realm
        @builder = builder
      end

      def call
        return unless realm.build_reek

        builder.call(realm.with(template_path: "%project_name%/.reek.yml.erb")).render
      end

      private

      attr_reader :realm, :builder
    end
  end
end
