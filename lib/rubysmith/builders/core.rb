# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds project skeleton core structure and minimum file support.
    class Core
      def self.call(realm, builder: Builder) = new(realm, builder: builder).call

      def initialize realm, builder: Builder
        @realm = realm
        @builder = builder
      end

      def call
        builder.call(realm.with(template_path: "%project_name%/lib/%project_name%.rb.erb")).render
        builder.call(realm.with(template_path: "%project_name%/.ruby-version.erb")).render
        nil
      end

      private

      attr_reader :realm, :builder
    end
  end
end
