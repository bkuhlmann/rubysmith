# frozen_string_literal: true

module Rubysmith
  module Builders
    module Rubocop
      # Builds project skeleton for Rubocop code quality support.
      class Setup
        def self.call(realm, builder: Builder) = new(realm, builder: builder).call

        def initialize realm, builder: Builder
          @realm = realm
          @builder = builder
        end

        def call
          return unless realm.build_rubocop

          builder.call(realm.with(template_path: "%project_name%/bin/rubocop.erb"))
                 .render
                 .permit 0o755

          builder.call(realm.with(template_path: "%project_name%/.rubocop.yml.erb")).render
        end

        private

        attr_reader :realm, :builder
      end
    end
  end
end
