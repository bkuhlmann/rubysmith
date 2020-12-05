# frozen_string_literal: true

module Rubysmith
  module Builders
    module RSpec
      # Builds RSpec spec helper for project skeleton.
      class Helper
        def self.call realm, builder: Builder
          new(realm, builder: builder).call
        end

        def initialize realm, builder: Builder
          @realm = realm
          @builder = builder
        end

        def call
          return unless realm.build_rspec

          builder.call(realm.with(template_path: "%project_name%/spec/spec_helper.rb.erb"))
                 .render
                 .replace(/\n{3,}/, "\n\n")
                 .replace(/\n\s{2}(?=(require|Simple|using|Pathname|Dir))/, "\n")
        end

        private

        attr_reader :realm, :builder
      end
    end
  end
end
