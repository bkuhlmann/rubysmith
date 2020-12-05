# frozen_string_literal: true

module Rubysmith
  module Builders
    module RSpec
      # Builds RSpec shared context for temporary directories.
      class Context
        def self.call realm, builder: Builder
          new(realm, builder: builder).call
        end

        def initialize realm, builder: Builder
          @realm = realm
          @builder = builder
        end

        def call
          return unless realm.build_rspec

          realm.with(template_path: "%project_name%/spec/support/shared_contexts/temp_dir.rb.erb")
               .then { |new_realm| builder.call new_realm }
               .render
               .replace(/\n\s+\n\s+/, "\n  ")
        end

        private

        attr_reader :realm, :builder
      end
    end
  end
end
