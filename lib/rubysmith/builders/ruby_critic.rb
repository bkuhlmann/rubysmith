# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds project skeleton RubyCritic code quality support.
    class RubyCritic
      def self.call(realm, builder: Builder) = new(realm, builder: builder).call

      def initialize realm, builder: Builder
        @realm = realm
        @builder = builder
      end

      def call
        return unless realm.build_ruby_critic

        builder.call(realm.with(template_path: "%project_name%/.rubycritic.yml.erb")).render
      end

      private

      attr_reader :realm, :builder
    end
  end
end
