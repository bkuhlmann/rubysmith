# frozen_string_literal: true

module Rubysmith
  module Builders
    # Builds project skeleton Rake support.
    class Rake
      def self.call realm, builder: Builder
        new(realm, builder: builder).call
      end

      def initialize realm, builder: Builder
        @realm = realm
        @builder = builder
      end

      def call
        builder.call(realm.with(template_path: "%project_name%/Rakefile.erb"))
               .render
               .replace(/\[\s+/, "[")
               .replace(/\s+\]/, "]")
               .replace("  ", "")
               .replace(/\n+(?=require)/, "\n")
               .replace(/\n{2,}/, "\n\n")
        nil
      end

      private

      attr_reader :realm, :builder
    end
  end
end
